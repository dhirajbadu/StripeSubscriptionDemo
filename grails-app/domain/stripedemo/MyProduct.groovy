package stripedemo

class MyProduct {

    String name

    String description

    String url

    String stripeProductId

    static constraints = {
        url(nullable: true, blank: true)
        stripeProductId(nullable: true, blank: true)
    }
}
