//
//  OrderVC.swift
//  e-shop
//
//  Created by surendra kumar on 11/14/17.
//  Copyright © 2017 weza. All rights reserved.
//

import UIKit
import PassKit
import Stripe
import Braintree
import SwiftSpinner

class OrderVC: UIViewController {

    let manager = ApplePay()
    let stripManager = StripPay()
    let braintreeManager = BraintreePay()
    
    var index : Int?
    var braintree: BTAPIClient?
    var totalCartCharge = 0.0

    @IBOutlet var payButton: UIButton!
    @IBOutlet var totalCharge: UILabel!
    @IBOutlet var totalItem: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        totalItem.text = "Total Item : \(cartItems.count)"
        self.charge { (totalCharge) in
            self.totalCartCharge = totalCharge
            self.totalCharge.text = "Total Charge: \(totalCharge) USD"
        }
        manager.canmakePayment { (canmake) in
            if !canmake{
                self.payButton.isHidden = true
            }
        }
    }
    
    
    override func loadView() {
        Bundle.main.loadNibNamed("OrderVC", owner: self, options: nil)
    }
    func charge(completion : (Double)->()){
        for item in cartItems{
            let itemcost = item.item.price * Double(item.count)
            totalCartCharge = totalCartCharge + itemcost
        }
        completion(totalCartCharge)
    }
    
    @IBAction func pay(_ sender: Any) {
        self.chooseBetweenStripandBrainTreeforApplePay()
        
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func crreditCard(_ sender: Any) {
        let vc = CreditCardVC()
        vc.totalcharge = totalCartCharge
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
    }
    
    @IBAction func payPal(_ sender: Any) {
        self.initializeBrainTreeUI()
        SwiftSpinner.show("Connecting to \ngateway...").addTapHandler({
          SwiftSpinner.hide()
        })
    }
    
    func chooseBetweenStripandBrainTreeforApplePay(){
        let alert = UIAlertController(title: "payment Option", message: "choose payment gateway (for Dev)", preferredStyle: .actionSheet)
        let strip = UIAlertAction(title: "Strip", style: UIAlertActionStyle.default) { (action) in
            self.index = 0
            self.initialiseApplePayController()
        }
        let brainTree = UIAlertAction(title: "BrainTree", style: UIAlertActionStyle.default) { (action) in
            self.index = 1
            self.initialiseApplePayController()
        }
        
        let cancle = UIAlertAction(title: "Cancle", style:.cancel, handler: nil)
        
        alert.addAction(strip)
        alert.addAction(brainTree)
        alert.addAction(cancle)
        self.present(alert, animated: true) {}
    }
    
    func initialiseApplePayController(){
        manager.requestForPayment() { (controller) in
                guard controller != nil else {
                    print("errror")
                        return
                    }
                controller?.delegate = self
                self.present(controller!, animated: true, completion: nil)
        }
    }
    
    func BrainTreePayment(forPayment payment : PKPayment,and price : Double,completion:@escaping (Error?)->()){
        braintreeManager.getClientToken { (token) in
            guard let clientToken = token else {
                self.Alert(title: "Token!", message: "Not found")
                return
            }
            let brainClient = BTAPIClient(authorization: clientToken)
            let applepayClient = BTApplePayClient(apiClient: brainClient!)
            applepayClient.tokenizeApplePay(payment, completion: { (nonce, error) in
                guard error == nil else{
                    self.Alert(title: "Nonce", message: "not found")
                    return
                }
                guard let payNonce = nonce else {return}
                self.braintreeManager.makeFinalPayment(nonce: payNonce.nonce, price: self.manager.effectivePrice!, completion: { (error) in
                    completion(error)
                })
            })
        }
    }
    
    func StripPayment(forPayment payment : PKPayment,and price : Double,completion:@escaping (Error?)->()){
        stripManager.createSTPToken(forPayment: payment) { (token, error) in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            guard let tokenF = token else {return}
            self.stripManager.makeFinalPayment(token: tokenF, price:self.manager.effectivePrice!, completion: { error in
                completion(error)
            })
        }
    }
    // CARD Payment
    func initializeBrainTreeUI(){
        braintreeManager.getClientToken { clientToken in
            guard clientToken != nil else {
                self.Alert(title: "Token!", message: "Not found")
                return
            }
            self.braintree = BTAPIClient(authorization: clientToken!)
            let dropInViewController = BTDropInViewController(apiClient: self.braintree!)
            dropInViewController.delegate = self
            SwiftSpinner.hide()
            self.present(dropInViewController, animated: true, completion: nil)
        }
    }
    
    @objc func userDidCancelPayment() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension OrderVC : PKPaymentAuthorizationViewControllerDelegate {
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {
        assert(index != nil, "choose between payment gatway")
        guard let i = self.index else {return}
        switch i {
        case 0:
            self.StripPayment(forPayment: payment, and: self.manager.effectivePrice!, completion: { error in
                guard error == nil else {
                    completion(.failure)
                    return
                }
                completion(.success)
            })
        case 1:
            self.BrainTreePayment(forPayment: payment, and: self.manager.effectivePrice!, completion: { error in
                guard error == nil else {
                        completion(.failure)
                        return
                        }
                completion(.success)
                })
        default:
            break
        }
    }
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didSelect shippingMethod: PKShippingMethod, handler completion: @escaping (PKPaymentRequestShippingMethodUpdate) -> Void) {
        let summaryItems  = manager.getsummaryItems(forShipingMethod: shippingMethod)
        completion(PKPaymentRequestShippingMethodUpdate(paymentSummaryItems:summaryItems))
    }
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didSelectShippingContact contact: PKContact, handler completion: @escaping (PKPaymentRequestShippingContactUpdate) -> Swift.Void){
        
    }
}

extension OrderVC: BTDropInViewControllerDelegate{
    
    func drop(_ viewController: BTDropInViewController, didSucceedWithTokenization paymentMethodNonce: BTPaymentMethodNonce) {
        let paynonce = paymentMethodNonce.nonce
        braintreeManager.makeFinalPayment(nonce: paynonce, price: self.totalCartCharge, completion: {
            error in
        })
        dismiss(animated: true, completion: nil)
    }
    
    func drop(inViewControllerDidCancel viewController: BTDropInViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
}
