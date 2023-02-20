package stripedemo

class BootStrap {

    def init = { servletContext ->
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
    }
    def destroy = {
    }
}
