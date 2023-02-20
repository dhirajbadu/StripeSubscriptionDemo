package stripedemo

enum SubscriptionType {
    FREE("Free"),
    NO_SUBSCRIPTION("No Subscription"),
    BASIC("Basic"),
    PREMIUM("Premium")

    private final String text;

    SubscriptionType(String text) {
        this.text = text
    }

    String getText() {
        return text
    }
}