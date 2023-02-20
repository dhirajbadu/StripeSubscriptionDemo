'use strict';

var stripe = Stripe('pk_test_51M5PRYDxwUhLBVzYuCIlXsINOvRmYDIzwdf8BcBpW7CVSXlU1OompmgHiNfMsNxvMs9XtZMX9SBrx71H32ooHuqN00Aip2UrEb');

function registerElements(elements) {

    var form = document.getElementById('checkout-form');
    var error = form.querySelector('.error');
    var errorMessage = error.querySelector('.message');

    function enableInputs() {
        Array.prototype.forEach.call(
            form.querySelectorAll(
                "input[type='text'], input[type='email'], input[type='tel']"
            ),
            function (input) {
                input.removeAttribute('disabled');
            }
        );
    }

    function disableInputs() {
        Array.prototype.forEach.call(
            form.querySelectorAll(
                "input[type='text'], input[type='email'], input[type='tel']"
            ),
            function (input) {
                input.setAttribute('disabled', 'true');
            }
        );
    }

    function triggerBrowserValidation() {
        // The only way to trigger HTML5 form validation UI is to fake a user submit
        // event.
        var submit = document.createElement('input');
        submit.type = 'submit';
        submit.style.display = 'none';
        form.appendChild(submit);
        submit.click();
        submit.remove();
    }

    // Listen for errors from each Element, and show error messages in the UI.
    var savedErrors = {};
    elements.forEach(function (element, idx) {
        element.on('change', function (event) {
            if (event.error) {
                error.classList.add('visible');
                savedErrors[idx] = event.error.message;
                errorMessage.innerText = event.error.message;
            } else {
                savedErrors[idx] = null;

                // Loop over the saved errors and find the first one, if any.
                var nextError = Object.keys(savedErrors)
                    .sort()
                    .reduce(function (maybeFoundError, key) {
                        return maybeFoundError || savedErrors[key];
                    }, null);

                if (nextError) {
                    // Now that they've fixed the current error, show another one.
                    errorMessage.innerText = nextError;
                } else {
                    // The user fixed the last error; no more errors.
                    error.classList.remove('visible');
                }
            }
        });
    });

    // Listen on the form's 'submit' handler...
    form.addEventListener('submit', function (e) {
        e.preventDefault();

        // Trigger HTML5 validation UI on the form if any of the inputs fail
        // validation.
        var plainInputsValid = true;
        Array.prototype.forEach.call(form.querySelectorAll('input'), function (
            input
        ) {
            if (input.checkValidity && !input.checkValidity()) {
                plainInputsValid = false;
                return;
            }
        });
        if (!plainInputsValid) {
            triggerBrowserValidation();
            return;
        }

        // Disable all inputs.
        disableInputs();

        // Gather additional customer data we may have collected in our form.
        var firstName = form.querySelector('#firstName');
        var lastName = form.querySelector('#latsName');
        var address = form.querySelector('#address');
        var city = form.querySelector('#city');
        var state = form.querySelector('#state');
        var zip = form.querySelector('#zip');
        var name = firstName + " " + lastName
        var additionalData = {
            name: name ? name.value : undefined,
            address_line1: address ? address.value : undefined,
            address_city: city ? city.value : undefined,
            address_state: state ? state.value : undefined,
            address_zip: zip ? zip.value : undefined,
        };

        // Use Stripe.js to create a token. We only need to pass in one Element
        // from the Element group in order to create a token. We can also pass
        // in the additional customer data we collected in our form.
        if (document.getElementById('updateCardToken') != null) {
            //for upgrading of downgrading the cards
            stripeTokenHandler(document.getElementById('updateCardToken').value)
        } else {
            stripe.createToken(elements[0], additionalData).then(function (result) {
                // Stop loading!
                var url = window.location.origin + "/payment/savePaymentInfo";

                if (result.token) {
                    stripeTokenHandler(result.token.id)
                } else {
                    // Otherwise, un-disable inputs.
                    enableInputs();
                }
            });
        }
    });
}

function stripeTokenHandler(token) {
    var form = document.getElementById('checkout-form');
    var email = form.querySelector('#email').value;
    var amount = form.querySelector('#amount').value;
    var plan = form.querySelector('#plan').value;
    var planName = form.querySelector('#planName').value;
    var firstName = form.querySelector('#firstName').value;
    var lastName = form.querySelector('#latsName').value;
    var address = form.querySelector('#address').value;
    var city = form.querySelector('#city').value;
    var state = form.querySelector('#state').value;
    var zip = form.querySelector('#zip').value;
    var url = window.location.origin + "/customer/saveSubscription";

    // Use fetch to send the token and customer information to your server
    fetch(url, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            token: token,
            name: firstName + " " + lastName,
            firstName: firstName,
            lastName: lastName,
            email: email,
            plan: plan,
            planName: planName,
            amount: amount,
            address: address,
            city: city,
            state: state,
            zip: zip,
        })
    })
        .then(function (response) {
            if (response.ok) {
                // Redirect the customer to a success page
                window.location.href = window.location.origin + '/success';
            } else {
                // Handle errors
                console.error('Error processing payment');
            }
        });
}