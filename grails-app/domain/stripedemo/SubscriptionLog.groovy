package stripedemo

class SubscriptionLog {

    String subscriptionToken

    String subscriptionId

    String stripeCustomerId

    String subscriptionProductId

    String status

    Date createdDate = new Date()

    static constraints = {
    }
}
