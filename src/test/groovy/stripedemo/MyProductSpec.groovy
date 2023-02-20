package stripedemo

import grails.testing.gorm.DomainUnitTest
import spock.lang.Specification

class MyProductSpec extends Specification implements DomainUnitTest<MyProduct> {

    def setup() {
    }

    def cleanup() {
    }

    void "test something"() {
        expect:"fix me"
            true == false
    }
}
