package stripedemo

class SubscriptionPlan {
    SubscriptionType title

    SubscriptionPeriod planType

    Long rate


    public SubscriptionPlan(SubscriptionType title, SubscriptionPeriod planType, Long rate) {
        this.title = title
        this.planType = planType
        this.rate = rate
    }
    static constraints = {
        planType(null: false, nullable: false)
        rate(null: false, nullable: false)
    }
}
