package stripedemo
import  stripedemo.PaymentStatus
class Payment {

    String customerId

    String stripeInvoiceId

    Long total

    Date paymentDate

    String subscriptionId

    boolean paid

    PaymentStatus status

    static constraints = {
        stripeInvoiceId nullable: true, blank: true
        paid nullable: true, blank: true
        total nullable: true, blank: true
    }
}
