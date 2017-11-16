import braintree
import stripe
from flask import Flask
from flask import request
from flask import json

braintree.Configuration.configure(
                                  braintree.Environment.Sandbox,
                                  '8vcr8hbq5yknmx7p',
                                  '68wxydkzwpxms2vp',
                                  '3ff43ddfcc2e2b97718917952d19c070'
                                  )
app = Flask(__name__)

@app.route("/client_token", methods=["GET"])
def client_token():
    return braintree.ClientToken.generate()
@app.route("/checkout", methods=["POST"])
def create_purchase():
#    def f(nonce_from_the_client):
#        nonce_from_the_client = request.form["sandbox_4mpg9vyr_8vcr8hbq5yknmx7p"]
# Use payment method nonce here...
        json  = request.get_json(force=True)
        nonce = json["payment_method_nonce"]
        ammount = json["amount"]
        result = braintree.Transaction.sale({
                                    "amount": ammount,
                                    "payment_method_nonce": nonce,
                                    "options": {
                                            "submit_for_settlement": True
                                                }
                                    })
        if result.is_success:
            print("success!: " + result.transaction.id)
        elif result.transaction:
            print("Error processing transaction:")
            print("  code: " + result.transaction.processor_response_code)
            print("  text: " + result.transaction.processor_response_text)
        else:
            for error in result.errors.deep_errors:
                print("attribute: " + error.attribute)
                print("  code: " + error.code)
                print("  message: " + error.message)
        return "success"

#1
@app.route('/pay', methods=['POST'])
def pay():
    
    #2
    # Set this to your Stripe secret key (use your test key!)
    stripe.api_key = "sk_test_4HKKLEaGa6YweA50gknGDYEf"
    
    #3
    # Parse the request as JSON
    json = request.get_json(force=True)
    
    # Get the credit card details
    token = json['stripeToken']
    amount = json['amount']
    description = json['description']
    
    # Create the charge on Stripe's servers - this will charge the user's card
    try:
        #4
        charge = stripe.Charge.create(
                                      amount=amount,
                                      currency="usd",
                                      card=token,
                                      description=description
                                      )
    except stripe.CardError, e:
        # The card has been declined
        pass
    
    #5
    return "Success!"

if __name__ == '__main__':
    # Set as 0.0.0.0 to be accessible outside your local machine
    app.run(debug=True, host= '0.0.0.0')
