# Stripe Subscription Demo Application
### Account Setup in Stripe
1. Sign up from here https://dashboard.stripe.com/register
2. login after successful account registration
3. Create account from left corner
4. Setup webhook
    - Go to `Developers` from right right
    - Go to `Webhooks`
    - Click on `Add Endpoints`
    - Use the `Endpoint URL` of the form `base_URL`/`webhook/handleStripeEvent`
    - Type description about webhooks
    - Select events from `Select events to listen to` -> `Select events`
    - Click on `Add Endpoint`
### Environment Variable
    1. STRIPE_SECRET = 'secrert key from your stripe account'
    2. STRIPE_PUBLISHABLE_KEY = 'publishable key from stripe account'
### Build and Run an Application
~~~
Note: Change the database credentials from application.yml based on env
~~~
## Run locally
~~~
grails run-app;
~~~
#### Build and Deploy

