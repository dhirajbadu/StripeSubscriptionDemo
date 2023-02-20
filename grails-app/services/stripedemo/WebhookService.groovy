package stripedemo

import grails.gorm.transactions.Transactional

@Transactional
class WebhookService {

    StripeService stripeService

    def handleEvents(events) {
        def json = events
        try {
            switch (json.type) {
                case 'invoice.payment_succeeded':
                    stripeService.eventInvoicePaymentSucceeded(json)
                    break
                case 'invoice.payment_failed':
                    stripeService.eventInvoicePaymentFailed(json)
                    break
                case 'customer.subscription.deleted':
                    stripeService.eventCustomerSubscriptionDeleted(json)
                    break
                case 'customer.subscription.updated':
                    stripeService.eventCustomerSubscriptionUpdated(json)
                    break
                default:
                    System.out.println("Unhandled event type: " + json.type);
            }
            return [status: 200, message: "Success"]
        } catch (Exception x) {
            log.error("Exception occurred while handling events from webhook." + x)
            throw x
        }
    }
}
