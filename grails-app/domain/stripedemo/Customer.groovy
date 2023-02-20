package stripedemo

class Customer {

    String firstName

    String lastName

    String email

    String address

    String city

    String state

    String zip

    String subscriptionToken

    String subscriptionId

    String stripeCustomerId

    String subscriptionProductId

    boolean isSubscribed = false

    boolean isSubscriptionCanceled = false

    SubscriptionType currentSubscription = SubscriptionType.FREE

    SubscriptionPeriod currentSubscriptionType = SubscriptionPeriod.FREE

    static hasOne = [customerSubscription: CustomerSubscription]

    static constraints = {
        firstName(nullable: false, blank: false)
        lastName(nullable: false, blank: false)
        email(nullable: false, blank: false, unique: true)
        subscriptionToken(nullable: true, blank: true)
        subscriptionId(nullable: true, blank: true)
        stripeCustomerId(nullable: true, blank: true)
        subscriptionProductId(nullable: true, blank: true)
    }
}
