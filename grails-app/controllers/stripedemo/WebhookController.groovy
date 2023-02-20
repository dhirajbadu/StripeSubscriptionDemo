package stripedemo

import grails.converters.JSON

public class WebhookController {
 WebhookService webhookService

    def handleStripeEvent() {
        def events = request.getJSON()
        render webhookService.handleEvents(events) as JSON
    }

}
