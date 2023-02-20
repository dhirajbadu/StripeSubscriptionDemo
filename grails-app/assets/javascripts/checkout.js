// Set up Stripe.js and create a card element
var stripe = Stripe('pk_test_51M5PRYDxwUhLBVzYuCIlXsINOvRmYDIzwdf8BcBpW7CVSXlU1OompmgHiNfMsNxvMs9XtZMX9SBrx71H32ooHuqN00Aip2UrEb');
var elements = stripe.elements();
var cardStyle = {
    base: {
        fontSize: '16px',
        color: '#32325d',
        border: '1px solid red'
    },
    invalid: {
        color: '#fa755a',
    },
    placeholder: {
        color: '#4ed735',
    },
};
var card = elements.create('card', {style: cardStyle});
//mount the card element to the DOM element
card.mount('#stripeElementDiv');
// var cardNumberElement = elements.create('cardNumber');
// cardNumberElement.mount('#card-number');
//
// var cardExpiryElement = elements.create('cardExpiry');
// cardExpiryElement.mount('#card-expiry');
//
// var cardCvcElement = elements.create('cardCvc');
// cardCvcElement.mount('#card-cvc');
// Handle form submission
var form = document.getElementById('checkout-form');
form.addEventListener('submit', function (event) {
    event.preventDefault();
    stripe.createToken(card).then(function (result) {
        console.log("Result=>" + result)
        if (result.error) {
            var errorElement = document.getElementById('card-errors');
            errorElement.textContent = result.error.message;
        } else {
            // Send the token to your server
            stripeTokenHandler(result.token);
        }
    });
});

// Submit the token to your server
function stripeTokenHandler(token) {
    var form = document.getElementById('checkout-form');
    var firstName = form.querySelector('input[name="firstName"]').value;
    var lastName = form.querySelector('input[name="lastName"]').value;
    var email = form.querySelector('input[name="email"]').value;
    var amount = form.querySelector('input[name="amount"]').value;
    var plan = form.querySelector('input[name="plan"]').value;
    var planName = form.querySelector('input[name="planName"]').value;
    var url = window.location.origin + "/payment/savePaymentInfo";

    // Use fetch to send the token and customer information to your server
    fetch(url, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            token: token.id,
            name: firstName + " " + lastName,
            firstName: firstName,
            lastName: lastName,
            email: email,
            plan: plan,
            planName: planName,
            amount: amount
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