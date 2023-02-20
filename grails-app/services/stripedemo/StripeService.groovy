package stripedemo

import com.stripe.Stripe
import com.stripe.exception.StripeException
import com.stripe.model.Card
import com.stripe.model.Plan
import com.stripe.model.Price
import com.stripe.model.Product
import com.stripe.model.Customer
import com.stripe.model.Subscription
import com.stripe.model.Token
import com.stripe.param.CustomerCreateParams
import com.stripe.param.PlanCreateParams
import com.stripe.param.PriceCreateParams
import com.stripe.param.ProductCreateParams
import com.stripe.param.SubscriptionCreateParams
import com.stripe.param.SubscriptionUpdateParams
import grails.gorm.transactions.Transactional
import grails.util.Holders


@Transactional
class StripeService {

    CustomerService customerService
//    init stripe
    def init() {
        Stripe.apiKey = Holders.config.stripe.secret
    }
//    create plan
    def createPlan(SubscriptionPlan subscriptionPlan, MyProduct product) {
        def interval = PlanCreateParams.Interval.YEAR
        if (subscriptionPlan?.planType.equals(SubscriptionPeriod.MONTHLY)) {
            interval = PlanCreateParams.Interval.MONTH
        } else if (subscriptionPlan?.planType.equals(SubscriptionPeriod.MONTHLY)) {
            interval = PlanCreateParams.Interval.YEAR
        }
        PlanCreateParams params =
                PlanCreateParams.builder()
                        .setCurrency("usd")
                        .setNickname(subscriptionPlan?.title.text.toString())
                        .setProduct(product.getStripeProductId())
                        .setInterval(interval)
                        .setAmount(subscriptionPlan.rate * 100L)
                        .build()
        try {
            Plan plan = Plan.create(params)
            return plan
        } catch (StripeException e) {
            e.printStackTrace();
        }
        return null
    }
//    create stripe product
    def createProduct(params) {
        ProductCreateParams productParams =
                ProductCreateParams.builder()
                        .setName(params?.name)
                        .setDescription(params?.description)
                        .build();
        Product product = Product.create(productParams);
        return product
    }

//stripe customer
    def createCustomer(request) {
        CustomerCreateParams params =
                CustomerCreateParams.builder()
                        .setEmail(request?.email)
                        .setName(request?.name)
                        .setSource(request?.token)
                        .build();

        Customer customer = Customer.create(params);
        return customer
    }

    def getPlanFromStripe(planId) {
        return Plan.retrieve(planId)
    }

    def freeSubscription(request, customer) {
        try {
            log.warn("Subscription process started")
            // Create a new plan for the subscription
            SubscriptionPlan subscriptionPlan= SubscriptionPlan.findByPlanType(SubscriptionPeriod.FREE)
            Plan plan   = getPlanFromStripe(subscriptionPlan?.getStripePlanId())
            // Set up the subscription parameters
            SubscriptionCreateParams subscriptionCreateParams = SubscriptionCreateParams.builder()
                    .setCustomer(customer.getId())
                    .addItem(SubscriptionCreateParams.Item.builder()
                            .setPlan(plan.getId())
                            .build())
                    .setTrialPeriodDays(30) // Replace with the trial period in days (30 days free subscription)
                    .build();

            // Create the subscription
            Subscription subscription = Subscription.create(subscriptionCreateParams);

            System.out.println("Subscription created: " + subscription.getId());
            saveCustomer(subscription, request, customer, plan?.getProduct())
            saveSubscriptionLogs(request, customer, subscription, plan.getProduct())
            return subscription
        } catch (StripeException e) {
            // Handle any errors
            System.err.println("Error: " + e.getMessage());
        }
        return null
    }

    // save customer subscription
    def saveCustomerDetails(request) {
//        create a stripe customer
        Customer customer
        def subscription
        stripedemo.Customer client = stripedemo.Customer.findByEmail(request?.email)
//        if the customer already exists
        if (client) {
            customer = Customer.retrieve(client?.getStripeCustomerId())
            if (client?.isSubscriptionCanceled) {
//                if the previous subscription was canceled , create new subscription
                subscription = chargeTokenBasedRecurringSubscription(request, customer)
                client?.isSubscriptionCanceled = false
            } else {
                subscription = updateTokenBasedSubscription(client, customer, request)
            }
            client.currentSubscription = (request?.planName as SubscriptionType)
            client.currentSubscriptionType = (request?.plan as SubscriptionPeriod)
            client.save(flush: true, failOnError: true)
            System.out.println("Subscription updated successfully." + subscription.getId());
            return subscription
        } else {
            customer = createCustomer(request)
            if ((request?.plan == "FREE" || request?.plan == null) && (request?.planName == "FREE" || request?.planName == null)) {
                subscription = freeSubscription(request, customer)
            } else {
                subscription = chargeTokenBasedRecurringSubscription(request, customer)
            }

            if (subscription) {
                System.out.println("Payment successful, with subscription ID: " + subscription.getId());
                return subscription
            } else {
                System.out.println("Payment failed")
                return null
            }
        }
        return null
    }

    def createSubscriptionPrice(productId, request, rate) {
        def interval = PriceCreateParams.Recurring.Interval.YEAR
        if (request?.plan.equals("MONTHLY")) {
            interval = PriceCreateParams.Recurring.Interval.MONTH
        } else if (request?.plan.equals("YEARLY")) {
            interval = PriceCreateParams.Recurring.Interval.YEAR
        }
        PriceCreateParams params =
                PriceCreateParams
                        .builder()
                        .setProduct(productId)
                        .setCurrency("usd")
                        .setUnitAmount(rate * 100L)
                        .setRecurring(
                                PriceCreateParams.Recurring
                                        .builder()
                                        .setInterval(interval)
                                        .build())
                        .build();
        Price price = Price.create(params);
        return price
    }

    def updateTokenBasedSubscription(client, customer, request) {
        Subscription subscription = Subscription.retrieve(client.getSubscriptionId())
        SubscriptionType subscriptionType = request?.planName as SubscriptionType
        SubscriptionPeriod subscriptionPeriod = request?.plan as SubscriptionPeriod
        SubscriptionPlan subscriptionPlan = SubscriptionPlan.findByTitleAndPlanType(subscriptionType, subscriptionPeriod)
        Plan plan   = getPlanFromStripe(subscriptionPlan?.getStripePlanId())
//        Price price = createSubscriptionPrice(plan?.getProduct(), request, subscriptionPlan.rate)
        Long trialEndPeriod = System.currentTimeMillis() / 1000L
        SubscriptionUpdateParams params =
                SubscriptionUpdateParams.builder()
                        .setTrialEnd(trialEndPeriod)
                        .setProrationBehavior(SubscriptionUpdateParams.ProrationBehavior.CREATE_PRORATIONS)
                        .addItem(
                                SubscriptionUpdateParams.Item.builder()
                                        .setId(subscription.getItems().getData().get(0).getId())
                                        .setPlan(plan.getId())
                                        .build())
                        .build();

        subscription.update(params);
        saveCustomer(subscription, request, customer, plan?.getProduct())
        saveSubscriptionLogs(request, customer, subscription, plan?.getProduct())
        return subscription
    }

    def chargeTokenBasedRecurringSubscription(request, customer) {
        try {
            log.warn("Subscription process started")
            // Create a new plan for the subscription
            SubscriptionType subscriptionType = request?.planName as SubscriptionType
            SubscriptionPeriod subscriptionPeriod = request?.plan as SubscriptionPeriod
            SubscriptionPlan subscriptionPlan = SubscriptionPlan.findByTitleAndPlanType(subscriptionType, subscriptionPeriod)
            Plan plan   = getPlanFromStripe(subscriptionPlan?.getStripePlanId())
            // Set up the subscription parameters
            SubscriptionCreateParams subscriptionCreateParams = SubscriptionCreateParams.builder()
                    .setCustomer(customer.getId())
                    .addItem(SubscriptionCreateParams.Item.builder()
                            .setPlan(plan.getId())
                            .build())
//                    .setTrialPeriodDays(0)
                    .build();

            // Create the subscription
            Subscription subscription = Subscription.create(subscriptionCreateParams);

            System.out.println("Subscription created: " + subscription.getId());
            saveCustomer(subscription, request, customer, plan?.getProduct())
            saveSubscriptionLogs(request, customer, subscription, plan?.getProduct())
            return subscription
        } catch (StripeException e) {
            // Handle any errors
            System.err.println("Error: " + e.getMessage());
        }
        return null
    }

//    save the logs of each event
    @Transactional
    def saveSubscriptionLogs(request, customer, subscription, productId) {
        SubscriptionLog subscriptionLog = new SubscriptionLog()
        subscriptionLog.subscriptionToken = request?.token
        subscriptionLog.subscriptionId = subscription?.getId()
        subscriptionLog.stripeCustomerId = customer?.getId()
        subscriptionLog.status = subscription.getStatus()
        subscriptionLog.subscriptionProductId = productId
        subscriptionLog.save(flush: true, failOnError: true)
    }

    @Transactional
    def saveCustomer(subscription, request, customer, productId) {
        stripedemo.Customer customer1 = stripedemo.Customer.findByEmail(request?.email)
        if (!customer1) {
            customer1 = new stripedemo.Customer()
        }
        customer1.setFirstName(request?.firstName)
        customer1.setLastName(request?.lastName)
        customer1.setEmail(request?.email)
        customer1.setAddress(request?.address)
        customer1.setCity(request?.city)
        customer1.setZip(request?.zip)
        customer1.setState(request?.state)
        customer1.setEmail(request?.email)
        customer1.setIsSubscribed(true)
        customer1.setStripeCustomerId(customer?.getId())
        customer1.setSubscriptionProductId(productId)
        customer1.setSubscriptionToken(request?.token)
        customer1.setSubscriptionToken(request?.token)
        customer1.setSubscriptionId(subscription?.getId())
        def customerSubscription = customer1?.customerSubscription
        if (!customerSubscription) {
            customerSubscription = new CustomerSubscription()
        }
        // Access subscription data
        customerSubscription.subscriptionId = subscription.getId();
        customerSubscription.subscriptionStatus = subscription.getStatus();
        customerSubscription.subscriptionCreated = new Date(subscription.getCreated() * 1000L);
        customerSubscription.currentPeriodStart = new Date(subscription.getCurrentPeriodStart() * 1000L);
        customerSubscription.currentPeriodEnd = new Date(subscription.getCurrentPeriodEnd() * 1000L);
        customerSubscription.endedAt = subscription.getEndedAt();
        customer1.setCustomerSubscription(customerSubscription)
        customerService.save(customer1)
        println "Customer created successfully."
    }

    def cancelSubscription(customerId) {
        stripedemo.Customer customer1 = stripedemo.Customer.findById(customerId)
//        if the subscription is already canceled
        if (customer1?.isSubscriptionCanceled) {
            return
        }
        Subscription deletedSubscription = null
        try {
            // Call the Stripe API to delete the subscription
            deletedSubscription = Subscription.retrieve(customer1?.getSubscriptionId()).cancel(null);
            customer1.isSubscriptionCanceled = true
            customer1.currentSubscription = SubscriptionType.NO_SUBSCRIPTION
            customer1.currentSubscriptionType = SubscriptionPeriod.NO_PLAN
            customer1.subscriptionId = null
            customer1.save(flush: true, failOnError: true)
            // Handle the success here
            System.out.println("Subscription with ID " + deletedSubscription.getId() + " has been deleted.");
        } catch (StripeException e) {
            // Handle the error here
            System.out.println("Error deleting subscription: " + e.getMessage());
        }
        return [subscription: deletedSubscription]
    }

//    handle request
    def getCardDetails(tokenString) {
        init()
        Token token = Token.retrieve(tokenString)
        Card card = (Card) token.getCard()
        return [lastFour: card.getLast4(), expiryDate: card.getExpMonth() + "/" + card.getExpYear(),]
    }

//    handle webhook events
    @Transactional
    def eventInvoicePaymentSucceeded(json) {
        init()
        Customer customer = Customer.retrieve(json.data.object.customer)
        Subscription subscription = Subscription.retrieve(json.data.object.subscription)
        def stripeInvoiceID = json.data.object.id

        if (Payment.findByStripeInvoiceId(stripeInvoiceID)) {
            return
        }

        def pe = json.data.object.lines.data[0].period.end
//        def periodEnd = new Date(pe*1000L)
        def date = new Date(json.data.object.created * 1000L)
        def payment = new Payment(
                customerId: customer.getId(),
                stripeInvoiceId: stripeInvoiceID,
                total: json.data.object.total,
                paymentDate: date,
                subscriptionId: subscription.getId(),
                paid: json.data.object.paid,
                status: PaymentStatus.SUCCEEDED
        )
        payment.save(failOnError: true, flush: true)
    }

    @Transactional
    def eventInvoicePaymentFailed(json) {
        init()
        Customer customer = Customer.retrieve(json.data.object.customer)
        Subscription subscription = Subscription.retrieve(json.data.object.subscription)
        def payment = new Payment(
                customerId: customer.getId(),
                paymentDate: new Date(),
//                stripeInvoiceId: subscription.getLatestInvoice(),
//                total: 0,
                subscriptionId: subscription.getId(),
                paid: false,
                status: PaymentStatus.FAILED
        )
        payment.save(failOnError: true, flush: true)
        return payment
    }

    @Transactional
    def eventCustomerSubscriptionDeleted(json) {
        init()
        Customer customer = Customer.retrieve(json.data.object.customer)
        Subscription subscription = Subscription.retrieve(json.data.object.id)
        def payment = new Payment(
                customerId: customer.getId(),
                paymentDate: new Date(),
//                total: 0,
//                stripeInvoiceId: subscription.getLatestInvoice(),
                subscriptionId: subscription.getId(),
                paid: false,
                status: PaymentStatus.CANCELED
        )
        payment.save(failOnError: true, flush: true)
        return payment
    }

    @Transactional
    def eventCustomerSubscriptionUpdated(json) {
        init()
        Customer customer = Customer.retrieve(json.data.object.customer)
        Subscription subscription = Subscription.retrieve(json.data.object.id)
        def payment = new Payment(
                customerId: customer.getId(),
//                stripeInvoiceId: subscription.getLatestInvoice(),
//                total: 0,
                paymentDate: new Date(),
                subscriptionId: subscription.getId(),
                paid: false,
                status: PaymentStatus.UPDATED
        )
        payment.save(failOnError: true, flush: true)
        return payment
    }

    def initProductAndPlan() {
        SubscriptionPeriod
        if (!SubscriptionPlan.findByTitleInList([SubscriptionType.BASIC, SubscriptionType.PREMIUM])) {
            SubscriptionPlan.saveAll(List.of(
                    new SubscriptionPlan(SubscriptionType.FREE, SubscriptionPeriod.FREE, 0L),
                    new SubscriptionPlan(SubscriptionType.BASIC, SubscriptionPeriod.MONTHLY, 9L),
                    new SubscriptionPlan(SubscriptionType.PREMIUM, SubscriptionPeriod.MONTHLY, 20L),
                    new SubscriptionPlan(SubscriptionType.BASIC, SubscriptionPeriod.YEARLY, 100L),
                    new SubscriptionPlan(SubscriptionType.PREMIUM, SubscriptionPeriod.YEARLY, 300L)
            ))
        }
//         create product in stripe and db
        if (!MyProduct.count()) {
            init()
            def productDetails = [name: "My Product", description: "My Product Description"]
            Product product = createProduct(productDetails)
            new MyProduct(name: product.getName(), description: product.getDescription(), url: product.getUrl(), stripeProductId: product.getId()).save(flush: true, failOnError: true)
            //        create plans in stripe
            MyProduct myProduct = MyProduct.findByName("My Product")
            SubscriptionPlan.list().each {
                def plan = createPlan(it, myProduct)
                it.stripePlanId = plan.getId()
                it.save(failOnError: true, flush: true)
            }
        }
    }

}
