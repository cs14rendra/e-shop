# e-shop
e-shop allow poeple to buy things online. Customer can browse throgh all the item. they can add it to cart. later they have multiple options for payments.

## Payment Gateway
Following payment gateway used:
1. Brantree
2. Strip
3. Paytm
## Installation

### Server Setup
This App use BranTree and Strip for payments, so to run this App, User need to setup for Braintree and Strip first on the Mac. 
A detailed information can be found on their websites regarding set-up of server.

- After setting Server, replace the keys in the server code  with your own keys.and run the Server. 
- Find the local adrees of your running server and replace server url with your own url in payment gateway groups of App.
- Setup a merchant Account on Apple developer Website for BrianTree
- Setup a merchant Account on Apple developer Website for Strip
- Make the Changes for same in xcode, as the apple documentation says
- Run the Server and find server running url and replace it with url given in payment gateway folder of App.

### Client
- Run the project on same machin if you have local host
- Browse and add item to cart
- Pay using any paymet method and check it in merchant account of Braintree and Strip if it is Sccess.

## Tasks

- [x] BranTree Server Setup
- [x] Strip Server Setup
- [x] Apple Pay Merchant Account for Strip
- [x] Apple Pay Merchant account for BrainTree
- [x] Credit Card Payments
- [x] Apple Pay Payments using Braintree or Strip
- [x] Paypal Payments
- [x] Paytm Client Side Setup
- [x] Paytm Server Setup
- [ ] Dynamic Product using some Backe end like Firebase or Amazon





## Requirements
- ios 11.0+
- xcode 9.0+

## Credits
- https://github.com/icanzilb/SwiftSpinner



## License
e-shop is available under the MIT license. See the LICENSE file for more info.
