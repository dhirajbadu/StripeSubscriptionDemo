package stripedemo

class BootStrap {

    StripeService stripeService
    def init = { servletContext ->
       stripeService.initProductAndPlan()
    }
    def destroy = {
    }
}
