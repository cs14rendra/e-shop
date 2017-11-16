//
//  StripViewController.swift
//  e-shop
//
//  Created by surendra kumar on 11/15/17.
//  Copyright © 2017 weza. All rights reserved.
//

import UIKit
import Stripe
import SwiftSpinner
import Braintree

class StripViewController: UIViewController{

    @IBOutlet var cardText: STPPaymentCardTextField!
    
    let stripManager = StripPay()
    let brainTreeManager = BraintreePay()
    
    // BrainTree
    var braintree: BTAPIClient?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func pay(_ sender: Any) {
//        self.payUsingCard()
        self.initializeBrainTreeUI()
    }
    
    // MARK : Strip
    func payUsingCard(){
        
        let cardParam = STPCardParams()
        cardParam.name = "Surendra kumar"
        cardParam.number = "4242424242424242"
        cardParam.expMonth = 12
        cardParam.expYear = 23
        cardParam.cvc = "424"
        SwiftSpinner.show("Connecting....")
        // Step 1:
        STPAPIClient.shared().createToken(withCard: cardParam) { (token, error) in
            guard error == nil else {
                self.Alert(title: "TokenError!", message: error!.localizedDescription)
                SwiftSpinner.hide()
                return
            }
            print(token!)
            SwiftSpinner.show("Making Payment...")
            // Step 2:
            self.stripManager.makeFinalPayment(token: token!, price: 777, completion: { (error) in
                guard error == nil else {
                    SwiftSpinner.show(progress: 50, title: "Payment \nFailed").addTapHandler({
                        SwiftSpinner.hide()
                    })
                    return
                }
                SwiftSpinner.show(progress: 100, title: "Payment \nSuccessful").addTapHandler({
                    SwiftSpinner.hide()
                })
            })
        }
    }
    
    // MARK : BrainTree
    
    func initializeBrainTreeUI(){
        brainTreeManager.getClientToken { token in
            guard let clientToken = token else {
                self.Alert(title: "Token!", message: "Not found")
                return
            }
            self.braintree = BTAPIClient(authorization: clientToken)
            let dropInViewController = BTDropInViewController(apiClient: self.braintree!)
            dropInViewController.delegate = self
            self.present(dropInViewController, animated: true, completion: nil)
        }
    }
    
    @objc func userDidCancelPayment() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension StripViewController: BTDropInViewControllerDelegate{
   
    func drop(_ viewController: BTDropInViewController, didSucceedWithTokenization paymentMethodNonce: BTPaymentMethodNonce) {
        let paynonce = paymentMethodNonce.nonce
        brainTreeManager.makeFinalPayment(nonce: paynonce, price: 888.0, completion: {
            error in
        })
        dismiss(animated: true, completion: nil)
    }
    
    func drop(inViewControllerDidCancel viewController: BTDropInViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }

}
