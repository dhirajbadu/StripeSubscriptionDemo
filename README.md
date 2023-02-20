# StripeSubscriptionDemo 
# Step 1: Setup a webhook in the stripe account from dashboards
```Developers->Webhooks->Add Endpoints-> Endpoint URL = baseURL+/webhook/handleStripeEvent```
# Step 2: Update the stripe secret from application.yml
```secret: "sk_test_51M"```
# Step 3: run and test
