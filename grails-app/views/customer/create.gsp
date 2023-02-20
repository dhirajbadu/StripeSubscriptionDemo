<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'customer.label', default: 'Customer')}"/>
    <title><g:message code="default.create.label" args="[entityName]"/></title>
    <script src="https://js.stripe.com/v3/"></script>
    <asset:link rel="stylesheet" href="stripeelements/stripe.css"/>
</head>

<body>
<div id="content" role="main">
    <div class="container">
        <section class="row">
            <a href="#create-customer" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>

            <div class="nav" role="navigation">
                <ul>
                    <li><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>
                    <li><g:link class="list" action="index"><g:message code="default.list.label"
                                                                       args="[entityName]"/></g:link></li>
                </ul>
            </div>
        </section>
        <section>
            <div class="cell example example2" id="example">
                <form id="checkout-form">
                    <g:if test="${customer}">
                        <input type="hidden" name="updateCardToken" id="updateCardToken" ,
                               value="${customer?.getSubscriptionToken()}">
                    </g:if>
                    <input type="hidden" id="name" name="name" , value="${params?.name ?: "Free"}">
                    <input type="hidden" id="description" name="description" ,
                           value="${params?.description ?: "Free Subscription"}">
                    <input type="hidden" id="amount" name="amount" , value="${subscriptionType?.rate ?: 0}">
                    <input type="hidden" id="plan" name="plan" , value="${params?.plan ?: "FREE"}">
                    <input type="hidden" id="planName" name="planName" , value="${params?.planName ?: "FREE"}">

                    <div data-locale-reversible>
                        <div class="col-6">
                            <div class="field">
                                <input id="firstName" data-tid="elements_examples.form.address_placeholder"
                                       class="input empty" type="text" placeholder="" required
                                       value="${customer?.firstName}">
                                <label for="firstName"
                                       data-tid="elements_examples.form.address_label">First Name</label>

                                <div class="baseline"></div>
                            </div>
                        </div>

                        <div class="col-6">
                            <div class="field">
                                <input id="latsName" data-tid="elements_examples.form.address_placeholder"
                                       class="input empty" type="text" placeholder="" required
                                       value="${customer?.lastName}">
                                <label for="latsName" data-tid="elements_examples.form.address_label">Last Name</label>

                                <div class="baseline"></div>
                            </div>
                        </div>

                        <div class="col-6">
                            <div class="field">
                                <input id="email" data-tid="elements_examples.form.address_placeholder"
                                       class="input empty" type="text" placeholder="" required
                                       value="${customer?.email}">
                                <label for="email" data-tid="elements_examples.form.address_label">Email</label>

                                <div class="baseline"></div>
                            </div>
                        </div>

                        <div class="col-6">
                            <div class="field">
                                <input id="address" data-tid="elements_examples.form.address_placeholder"
                                       class="input empty" type="text" placeholder="185 Berry St" required=""
                                       autocomplete="address-line1" value="${customer?.address}">
                                <label for="address" data-tid="elements_examples.form.address_label">Address</label>

                                <div class="baseline"></div>
                            </div>
                        </div>

                        <div class="row" data-locale-reversible>
                            <div class="field half-width">
                                <input id="city" data-tid="elements_examples.form.city_placeholder" class="input empty"
                                       type="text" placeholder="San Francisco" required="" autocomplete="address-level2"
                                       value="${customer?.city}">
                                <label for="city" data-tid="elements_examples.form.city_label">City</label>

                                <div class="baseline"></div>
                            </div>

                            <div class="field quarter-width">
                                <input id="state" data-tid="elements_examples.form.state_placeholder"
                                       class="input empty" type="text" placeholder="CA" required=""
                                       autocomplete="address-level1" value="${customer?.state}">
                                <label for="state" data-tid="elements_examples.form.state_label">State</label>

                                <div class="baseline"></div>
                            </div>

                            <div class="field quarter-width">
                                <input id="zip" data-tid="elements_examples.form.postal_code_placeholder"
                                       class="input empty" type="text" placeholder="94107" required=""
                                       autocomplete="postal-code" value="${customer?.zip}">
                                <label for="zip" data-tid="elements_examples.form.postal_code_label">ZIP</label>

                                <div class="baseline"></div>
                            </div>
                        </div>
                    </div>
                    <g:if test="${subscriptionCardDetails}">
                        <div class="row">
                            <div class="field half-width">
                                <label for="card-number"
                                       data-tid="elements_examples.form.card_number_label">Card number: ********${subscriptionCardDetails?.lastFour}</label>

                                <div class="baseline"></div>
                            </div>
                            <div class="field">
                                <label for="card-number"
                                       data-tid="elements_examples.form.card_number_label">Expiry Date: ${subscriptionCardDetails?.expiryDate}</label>

                                <div class="baseline"></div>
                            </div>
                        </div>
                        <div hidden>
                            <div class="row">
                                <div class="field half-width">
                                    <div id="card-number" class="input empty"></div>
                                    <label for="card-number"
                                           data-tid="elements_examples.form.card_number_label">Card number</label>

                                    <div class="baseline"></div>
                                </div>
                            </div>

                            <div class="row">
                                <div class="field half-width">
                                    <div id="card-expiry" class="input empty"></div>
                                    <label for="card-expiry"
                                           data-tid="elements_examples.form.card_expiry_label">Expiration</label>

                                    <div class="baseline"></div>
                                </div>

                                <div class="field half-width">
                                    <div id="card-cvc" class="input empty"></div>
                                    <label for="card-cvc" data-tid="elements_examples.form.card_cvc_label">CVC</label>

                                    <div class="baseline"></div>
                                </div>
                            </div>
                        </div>
                    </g:if>
                    <g:else>
                        <div class="row">
                            <div class="field half-width">
                                <div id="card-number" class="input empty"></div>
                                <label for="card-number"
                                       data-tid="elements_examples.form.card_number_label">Card number</label>

                                <div class="baseline"></div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="field half-width">
                                <div id="card-expiry" class="input empty"></div>
                                <label for="card-expiry"
                                       data-tid="elements_examples.form.card_expiry_label">Expiration</label>

                                <div class="baseline"></div>
                            </div>

                            <div class="field half-width">
                                <div id="card-cvc" class="input empty"></div>
                                <label for="card-cvc" data-tid="elements_examples.form.card_cvc_label">CVC</label>

                                <div class="baseline"></div>
                            </div>
                        </div>
                    </g:else>
                    <g:if test="${subscriptionType}">
                        <button type="submit"
                                data-tid="elements_examples.form.pay_button">Subscribe $${subscriptionType?.getRate() + "/" + subscriptionType?.getPlanType().text}</button>
                    </g:if>
                    <g:else>
                        <button type="submit" data-tid="elements_examples.form.pay_button">Create New Customer</button>
                    </g:else>
                    <div class="error" role="alert">
                        <span class="message"></span></div>
                </form>
            </div>
        </section>
    </div>
</div>
%{--<asset:javascript src="checkout.js"/>--}%
<asset:javascript src="stripe/index.js"/>
<asset:javascript src="stripe/stripe.js"/>
</body>
</html>
