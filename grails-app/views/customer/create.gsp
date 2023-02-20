<%--
  Created by IntelliJ IDEA.
  User: Pritam Thing
  Date: 2/20/2023
  Time: 8:04 PM
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<!doctype html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title data-tid="elements_examples.meta.title">Stripe Custom Checkout Form</title>
    <script src="https://js.stripe.com/v3/"></script>
    <link href="https://fonts.googleapis.com/css?family=Roboto" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css?family=Quicksand" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css?family=Source+Code+Pro" rel="stylesheet">
    <!-- CSS for custom checkout page -->
    <asset:link rel="stylesheet" href="stripeelements/stripe.css"/>
</head>
<body>
<script>
    var publishable_key ="${STRIPE_PUBLISHABLE_KEY}"
</script>
<div class="globalContent">
    <main>
        <section class="container-lg">
            <!--Stripe Custom Check out form-->
            <div class="cell example example5" id="example-5">
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

                    <div id="example5-paymentRequest">
                        <!--Stripe paymentRequestButton Element inserted here-->
                    </div>
                    <fieldset>
                        <legend class="card-only" data-tid="elements_examples.form.pay_with_card">Customer Details</legend>
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
                    </fieldset>
                    <fieldset>
                        <legend class="card-only" data-tid="elements_examples.form.pay_with_card">Card Details</legend>
                        <legend class="payment-request-available" data-tid="elements_examples.form.enter_card_manually">Or enter card details</legend>
                        <div class="row">
                            <div class="field">
                                <label for="cardHolderName" data-tid="elements_examples.form.name_label">Name</label>
                                <input id="cardHolderName" data-tid="elements_examples.form.name_placeholder" class="input" type="text" placeholder="Jane Doe" required="" autocomplete="name">
                            </div>
                        </div>
                        <div class="row">
                            <div class="field">
                                <label for="cardHolderEmail" data-tid="elements_examples.form.email_label">Email</label>
                                <input id="cardHolderEmail" data-tid="elements_examples.form.email_placeholder" class="input" type="text" placeholder="janedoe@gmail.com" required="" autocomplete="email">
                            </div>
                            <div class="field">
                                <label for="cardHolderPhone" data-tid="elements_examples.form.phone_label">Phone</label>
                                <input id="cardHolderPhone" data-tid="elements_examples.form.phone_placeholder" class="input" type="text" placeholder="(941) 555-0123" required="" autocomplete="tel">
                            </div>
                        </div>
                        <div data-locale-reversible>
                            <div class="row">
                                <div class="field">
                                    <label for="cardAddress" data-tid="elements_examples.form.address_label">Address</label>
                                    <input id="cardAddress" data-tid="elements_examples.form.address_placeholder" class="input" type="text" placeholder="185 Berry St" required="" autocomplete="address-line1">
                                </div>
                            </div>
                            <div class="row" data-locale-reversible>
                                <div class="field">
                                    <label for="cardCity" data-tid="elements_examples.form.city_label">City</label>
                                    <input id="cardCity" data-tid="elements_examples.form.city_placeholder" class="input" type="text" placeholder="San Francisco" required="" autocomplete="address-level2">
                                </div>
                                <div class="field">
                                    <label for="cardState" data-tid="elements_examples.form.state_label">State</label>
                                    <input id="cardState" data-tid="elements_examples.form.state_placeholder" class="input empty" type="text" placeholder="CA" required="" autocomplete="address-level1">
                                </div>
                                <div class="field">
                                    <label for="cardZip" data-tid="elements_examples.form.postal_code_label">ZIP</label>
                                    <input id="cardZip" data-tid="elements_examples.form.postal_code_placeholder" class="input empty" type="text" placeholder="94107" required="" autocomplete="postal-code">
                                </div>
                            </div>
                        </div>
                        <g:if test="${subscriptionCardDetails}">
                            <div class="row">
                                <div class="field half-width">
                                    <label for="card"
                                           data-tid="elements_examples.form.card_number_label">Card: ********${subscriptionCardDetails?.lastFour}</label>

                                    <div class="baseline"></div>
                                </div>
                                <div class="field">
                                    <label for="card"
                                           data-tid="elements_examples.form.card_number_label">Expiry Date: ${subscriptionCardDetails?.expiryDate}</label>
                                    <div class="baseline"></div>
                                </div>
                                <div id="card" class="input" hidden></div>
                            </div>
                        </g:if>
                        <g:else>
                            <div class="row">
                                <div class="field">
                                    <label for="card" data-tid="elements_examples.form.card_label">Card</label>
                                    <div id="card" class="input"></div>
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
                    </fieldset>
                    <div class="error" role="alert"><svg xmlns="http://www.w3.org/2000/svg" width="17" height="17" viewBox="0 0 17 17">
                        <path class="base" fill="#000" d="M8.5,17 C3.80557963,17 0,13.1944204 0,8.5 C0,3.80557963 3.80557963,0 8.5,0 C13.1944204,0 17,3.80557963 17,8.5 C17,13.1944204 13.1944204,17 8.5,17 Z"></path>
                        <path class="glyph" fill="#FFF" d="M8.5,7.29791847 L6.12604076,4.92395924 C5.79409512,4.59201359 5.25590488,4.59201359 4.92395924,4.92395924 C4.59201359,5.25590488 4.59201359,5.79409512 4.92395924,6.12604076 L7.29791847,8.5 L4.92395924,10.8739592 C4.59201359,11.2059049 4.59201359,11.7440951 4.92395924,12.0760408 C5.25590488,12.4079864 5.79409512,12.4079864 6.12604076,12.0760408 L8.5,9.70208153 L10.8739592,12.0760408 C11.2059049,12.4079864 11.7440951,12.4079864 12.0760408,12.0760408 C12.4079864,11.7440951 12.4079864,11.2059049 12.0760408,10.8739592 L9.70208153,8.5 L12.0760408,6.12604076 C12.4079864,5.79409512 12.4079864,5.25590488 12.0760408,4.92395924 C11.7440951,4.59201359 11.2059049,4.59201359 10.8739592,4.92395924 L8.5,7.29791847 L8.5,7.29791847 Z"></path>
                    </svg>
                        <span class="message"></span></div>
                </form>
                <div class="success">
                    <div class="icon">
                        <svg width="84px" height="84px" viewBox="0 0 84 84" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
                            <circle class="border" cx="42" cy="42" r="40" stroke-linecap="round" stroke-width="4" stroke="#000" fill="none"></circle>
                            <path class="checkmark" stroke-linecap="round" stroke-linejoin="round" d="M23.375 42.5488281 36.8840688 56.0578969 64.891932 28.0500338" stroke-width="4" stroke="#000" fill="none"></path>
                        </svg>
                    </div>
                    <h3 class="title" data-tid="elements_examples.success.title">Subscription successful</h3>
                    <p class="message"><span data-tid="elements_examples.success.message">Thanks for Subscribing. No money was charged, but we generated a token: </span><span class="token">tok_189gMN2eZvKYlo2CwTBv9KKh</span></p>
                    <a class="reset" href="#">
                        <svg width="32px" height="32px" viewBox="0 0 32 32" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
                            <path fill="#000000" d="M15,7.05492878 C10.5000495,7.55237307 7,11.3674463 7,16 C7,20.9705627 11.0294373,25 16,25 C20.9705627,25 25,20.9705627 25,16 C25,15.3627484 24.4834055,14.8461538 23.8461538,14.8461538 C23.2089022,14.8461538 22.6923077,15.3627484 22.6923077,16 C22.6923077,19.6960595 19.6960595,22.6923077 16,22.6923077 C12.3039405,22.6923077 9.30769231,19.6960595 9.30769231,16 C9.30769231,12.3039405 12.3039405,9.30769231 16,9.30769231 L16,12.0841673 C16,12.1800431 16.0275652,12.2738974 16.0794108,12.354546 C16.2287368,12.5868311 16.5380938,12.6540826 16.7703788,12.5047565 L22.3457501,8.92058924 L22.3457501,8.92058924 C22.4060014,8.88185624 22.4572275,8.83063012 22.4959605,8.7703788 C22.6452866,8.53809377 22.5780351,8.22873685 22.3457501,8.07941076 L22.3457501,8.07941076 L16.7703788,4.49524351 C16.6897301,4.44339794 16.5958758,4.41583275 16.5,4.41583275 C16.2238576,4.41583275 16,4.63969037 16,4.91583275 L16,7 L15,7 L15,7.05492878 Z M16,32 C7.163444,32 0,24.836556 0,16 C0,7.163444 7.163444,0 16,0 C24.836556,0 32,7.163444 32,16 C32,24.836556 24.836556,32 16,32 Z"></path>
                        </svg>
                    </a>
                </div>
            </div>
        </section>
    </main>
</div>

<!-- Scripts for each example: -->
<asset:javascript src="stripe/index.js"/>
<asset:javascript src="stripe/stripe.js"/>

</body>
</html>