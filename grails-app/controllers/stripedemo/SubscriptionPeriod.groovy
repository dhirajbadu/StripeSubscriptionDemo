package stripedemo

enum SubscriptionPeriod {
    MONTHLY("Months"),
    YEARLY("Year"),
    FREE("Free"),
    NO_PLAN("No Plan")

    private final String text;

    SubscriptionPeriod(String text) {
        this.text = text
    }

    String getText() {
        return text
    }
}