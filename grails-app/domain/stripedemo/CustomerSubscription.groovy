package stripedemo

class CustomerSubscription {

    String subscriptionId

    String subscriptionStatus

    Date subscriptionCreated

    Date currentPeriodStart

    Date currentPeriodEnd

    Date endedAt

    Customer customer

    static constraints = {
        endedAt(nullable: true, blank:true)
    }
}
