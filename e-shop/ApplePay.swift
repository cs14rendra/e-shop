//
//  ApplePay.swift
//  e-shop
//
//  Created by surendra kumar on 11/14/17.
//  Copyright © 2017 weza. All rights reserved.
//

import Foundation
import PassKit
let publisableKey = "pk_test_SrHU35nCqiToGG5R5zfOQKx6"
let secrete = "sk_test_4HKKLEaGa6YweA50gknGDYEf"

class ApplePay{
    let merchantID = "merchant.com.weza.e-shop"
    let supportedPaymentNertwork :[ PKPaymentNetwork ] = [.visa,.amex,.masterCard]
    var effectivePrice : Double?
    
    func canmakePayment(completion: (Bool)->()){
        let canMakeNetPayment = PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: supportedPaymentNertwork)
        let canmakePayment = PKPaymentAuthorizationViewController.canMakePayments()
        let canmake = canMakeNetPayment && canmakePayment
        completion(canmake)
    }
    
    func requestForPayment(completion:(PKPaymentAuthorizationViewController?)->()){
        let request = PKPaymentRequest()
        request.merchantIdentifier = merchantID
        request.supportedNetworks = supportedPaymentNertwork
        request.merchantCapabilities = PKMerchantCapability.capability3DS
        request.countryCode = "US"
        request.currencyCode = "USD"
        
        let shipingMethods = getAllShipingMethods()
        let summeryitems = getsummaryItems(forShipingMethod: shipingMethods.first!)
        let contact = getContact()
        request.shippingMethods = shipingMethods
        request.paymentSummaryItems = summeryitems
        request.requiredShippingContactFields = [PKContactField.emailAddress, PKContactField.name,.phoneNumber]
        request.shippingContact = contact
        
        request.requiredBillingContactFields = [.emailAddress,.name]
        request.billingContact = contact
        completion(PKPaymentAuthorizationViewController(paymentRequest: request))
    }
    
  
}

extension ApplePay {
    
    func getAllShipingMethods() -> [PKShippingMethod]{
        let Premiun = PKShippingMethod(label: "Premium", amount: 10)
        Premiun.detail = "get this item within 8 hours"
        Premiun.identifier = "1"
        
        let Light = PKShippingMethod(label: "Light", amount: 5)
        Light.detail = "get this item on some day"
        Light.identifier = "2"
        
        let SuperSonic = PKShippingMethod(label: "SuperSonic", amount: 9000)
        SuperSonic.detail = "look at your window, it's there"
        SuperSonic.identifier = "3"
        return [Premiun,Light,SuperSonic]
    }
    
    func getsummaryItems(forShipingMethod shipingMethod  : PKShippingMethod) -> [PKPaymentSummaryItem]{
        let shipingMethod = shipingMethod
        var temp = [PKPaymentSummaryItem]()
        var totalPrice = 0.0
        for item in cartItems {
            let price = NSDecimalNumber.init(value: item.item.price * Double(item.count))
            totalPrice = totalPrice + item.item.price * Double(item.count)
            temp.append(PKPaymentSummaryItem(label: item.item.name, amount: price))
        }
        let shipingCharge = shipingMethod.amount
        totalPrice = totalPrice + Double(truncating: shipingMethod.amount)
        self.effectivePrice = totalPrice
        temp.append(PKPaymentSummaryItem(label: "Shiping", amount: shipingCharge))
        temp.append(PKPaymentSummaryItem(label: "Total", amount: NSDecimalNumber.init(value: totalPrice ) ))
        return temp
    }
    
    func getContact() -> PKContact{
        let contact = PKContact()
        let number = CNPhoneNumber(stringValue: "9655915941")
        var name = PersonNameComponents()
        name.givenName = "sure"
        name.middleName = "kumar"
        name.familyName = "patel"
        
        contact.phoneNumber = number
        contact.emailAddress = "cs14rendra@gmail.com"
        contact.name = name
        return contact
    }
}
