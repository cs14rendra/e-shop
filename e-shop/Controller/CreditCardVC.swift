//
//  CreditCardVC.swift
//  e-shop
//
//  Created by surendra kumar on 11/16/17.
//  Copyright © 2017 weza. All rights reserved.
//

import UIKit
import Stripe
import SwiftSpinner

class CreditCardVC: UIViewController {
    
    var totalcharge : Double?
    let stripManager = StripPay()
    var cardField : STPPaymentCardTextField?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        cardField = STPPaymentCardTextField()
        self.view.addSubview(cardField!)
        cardField?.delegate = self
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(CreditCardVC.canclePay(sender:)))
        navigationItem.rightBarButtonItem  = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(CreditCardVC.performePay(sender:)))
    }
    
    @objc func canclePay(sender : Any){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func performePay(sender : Any){
        let cardparam = self.getcardParam(forcard: cardField!)
        self.makePayment(forCardParam: cardparam)
        SwiftSpinner.show("Connecting...")
        let vc = self.presentingViewController
        self.dismiss(animated: true, completion: {
            vc?.dismiss(animated: true, completion: nil)
        })
    }
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let navHeight = self.navigationController?.navigationBar.frame.height ?? 100
        cardField?.frame = CGRect(x: 10, y: 2 * navHeight, width: self.view.bounds.width - 20.0, height: 50)
    }
    
    func getcardParam(forcard card : STPPaymentCardTextField) -> STPCardParams{
        let cardParam = STPCardParams()
        cardParam.name = "random"
        cardParam.number = card.cardNumber
        cardParam.expMonth = card.expirationMonth
        cardParam.expYear = card.expirationYear
        cardParam.cvc = card.cvc
        return cardParam
    }
    
    func makePayment(forCardParam cardparam : STPCardParams){
        STPAPIClient.shared().createToken(withCard: cardparam) { (token, error) in
            guard error == nil else {
                self.Alert(title: "TokenError!", message: error!.localizedDescription)
                SwiftSpinner.hide()
                return
            }
            print(token!)
            SwiftSpinner.show("Making Payment...")
            // Step 2:
            self.stripManager.makeFinalPayment(token: token!, price: self.totalcharge!, completion: { (error) in
                guard error == nil else {
                    SwiftSpinner.show(progress: 50, title: "Payment \nFailed").addTapHandler({
                        SwiftSpinner.hide()
                        let root = getRootViewController()
                        let summary = paymentSummary()
                        summary.isSucees = false
                        root?.present(summary, animated: true, completion: nil)
                    })
                    return
                }
                SwiftSpinner.show(progress: 100, title: "Payment \nSuccessful").addTapHandler({
                    SwiftSpinner.hide()
                    let root = getRootViewController()
                    let summary = paymentSummary()
                    summary.isSucees = true
                    root?.present(summary, animated: true, completion: nil)
                    
                })
            })
        }
    }

}

extension CreditCardVC : STPPaymentCardTextFieldDelegate{}
