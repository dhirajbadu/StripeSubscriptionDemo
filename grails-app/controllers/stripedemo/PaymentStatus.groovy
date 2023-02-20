package stripedemo

enum PaymentStatus {
    SUCCEEDED("Succeeded"),
    FAILED("Failed"),
    CANCELED("Canceled"),
    UPDATED("Updated")

    private final String text;

    PaymentStatus(String text) {
        this.text = text
    }

    String getText() {
        return text
    }
}