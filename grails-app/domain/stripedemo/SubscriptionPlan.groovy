package stripedemo

class SubscriptionPlan {
    SubscriptionType title

    SubscriptionPeriod planType

    Long rate

    String stripePlanId


    public SubscriptionPlan(SubscriptionType title, SubscriptionPeriod planType, Long rate) {
        this.title = title
        this.planType = planType
        this.rate = rate
    }
    static constraints = {
        planType(null: false, nullable: false)
        rate(null: false, nullable: false)
        stripePlanId(null: false, nullable: false)
    }
}
