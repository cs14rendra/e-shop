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

class OrderVC: UIViewController {

    let stripManager = StripPay()
    let merchantID = "merchant.com.weza.e-shop"
    let supportedPaymentNertwork :[ PKPaymentNetwork ] = [.visa,.amex,.masterCard]
    let manager = ApplePay()
    
    @IBOutlet var payButton: UIButton!
    @IBOutlet var totalCharge: UILabel!
    @IBOutlet var totalItem: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        totalItem.text = "Total Item : \(cartItems.count)"
        self.charge { (totalCharge) in
            self.totalCharge.text = "Total Charge: \(totalCharge) USD"
        }
        manager.canmakePayment { (canmake) in
            if !canmake{
                self.payButton.isHidden = true
            }
        }
    }
    
    func charge(completion : (Double)->()){
        var totalCharge = 0.0
        for item in cartItems{
            let itemcost = item.item.price * Double(item.count)
            totalCharge = totalCharge + itemcost
        }
        completion(totalCharge)
    }

    override func loadView() {
        Bundle.main.loadNibNamed("OrderVC", owner: self, options: nil)
    }
    
    @IBAction func pay(_ sender: Any) {
    manager.requestForPayment() { (controller) in
            guard controller != nil else {
                print("errror")
                return
            }
            controller?.delegate = self
            self.present(controller!, animated: true, completion: nil)
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension OrderVC : PKPaymentAuthorizationViewControllerDelegate {
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {
        stripManager.createSTPToken(forPayment: payment) { (token, error) in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            guard let tokenF = token else {return}
            self.stripManager.makeFinalPayment(token: tokenF, price: self.manager.effectivePrice!, completion: { error in
                guard error == nil else {
                    self.Alert(title: "Failed!", message: "payment Failed")
                    return
                }
                
            })
        }
    }
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didSelect shippingMethod: PKShippingMethod, handler completion: @escaping (PKPaymentRequestShippingMethodUpdate) -> Void) {
        let summaryItems  = manager.getsummaryItems(forShipingMethod: shippingMethod)
        completion(PKPaymentRequestShippingMethodUpdate(paymentSummaryItems:summaryItems))
    }
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didSelectShippingContact contact: PKContact, handler completion: @escaping (PKPaymentRequestShippingContactUpdate) -> Swift.Void){
        
    }
   
    
}
