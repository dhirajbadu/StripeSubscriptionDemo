package stripedemo

import grails.validation.ValidationException

import static org.springframework.http.HttpStatus.*

class CustomerController {
    CustomerService customerService
    StripeService stripeService
    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    def index(Integer max) {
        params.max = Math.min(max ?: 10, 100)
        respond customerService.list(params), model: [customerCount: customerService.count()]
    }

    def show(Long id) {
        respond customerService.get(id)
    }

    def selectSubscriptionPlan() {
        redirect(action: "create", params: params)
    }

    def create() {
        Long id = params?.id ? Long.parseLong(params?.id) : null
        Customer customer = null
        def subscriptionType = null
        def subscriptionCardDetails = null
        if (id) {
            customer = customerService.get(id)
            subscriptionType = SubscriptionPlan.findByTitleAndPlanType(params?.planName, params?.plan)
            subscriptionCardDetails = stripeService.getCardDetails(customer?.getSubscriptionToken())
        }
        [customer: customer, subscriptionType: subscriptionType, subscriptionCardDetails: subscriptionCardDetails]
    }

    def subscription(Long id) {
        Customer customer = customerService.get(id)
        [basicSubscription  : SubscriptionPlan.findAllByTitle(SubscriptionType.BASIC),
         customer           : customer, premiumSubscription: SubscriptionPlan.findAllByTitle(SubscriptionType.PREMIUM),
         currentSubscription: customer?.getSubscriptionId()]
    }

    def cancelSubscription(Long id) {
        Customer customer = Customer.findById(id)
        if (customer == null) {
            return
        }
        stripeService.init()
        [subscription: stripeService.cancelSubscription(id)]
    }
//    def example5(){}

    def saveSubscription() {
        stripeService.init()
        def subscription = stripeService.saveCustomerDetails(request?.getJSON())
        if (subscription) {
            redirect(action: 'index')
        } else {
            redirect(uri: '/fail')
        }
    }

    def save(Customer customer) {
        if (customer == null) {
            notFound()
            return
        }

        try {
            customerService.save(customer)
            stripeService.init()
            stripeService.freeSubscription(customer)
        } catch (ValidationException e) {
            respond customer.errors, view: 'create'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'customer.label', default: 'Customer'), customer.id])
                redirect customer
            }
            '*' { respond customer, [status: CREATED] }
        }
    }

    def edit(Long id) {
        respond customerService.get(id)
    }

    def update(Customer customer) {
        if (customer == null) {
            notFound()
            return
        }

        try {
            customerService.save(customer)
        } catch (ValidationException e) {
            respond customer.errors, view: 'edit'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'customer.label', default: 'Customer'), customer.id])
                redirect customer
            }
            '*' { respond customer, [status: OK] }
        }
    }

    def delete(Long id) {
        if (id == null) {
            notFound()
            return
        }
        stripeService.init()
        stripeService.cancelSubscription(id)
        customerService.delete(id)
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'customer.label', default: 'Customer'), id])
                redirect action: "index", method: "GET"
            }
            '*' { render status: NO_CONTENT }
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'customer.label', default: 'Customer'), params.id])
                redirect action: "index", method: "GET"
            }
            '*' { render status: NOT_FOUND }
        }
    }
}
