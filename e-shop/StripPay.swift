//
//  StripPay.swift
//  e-shop
//
//  Created by surendra kumar on 11/16/17.
//  Copyright © 2017 weza. All rights reserved.
//

import Foundation
import Stripe
class StripPay{
    
    init() {
       Stripe.setDefaultPublishableKey(publisableKey)
    }
    
    func createSTPToken(forPayment payment: PKPayment, completion : @escaping (STPToken?,Error?)->()){
        STPAPIClient.shared().createToken(with: payment) { (token, error) in
            completion(token,error)
        }
    }
    
    func makeFinalPayment(token : STPToken,price : Double, completion : @escaping (Error?)->()){
        
            let url = NSURL(string: "http://0.0.0.0:5000/pay")  // Replace with computers local IP Address!
            let request = NSMutableURLRequest(url: url! as URL)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            //2
            let body = ["stripeToken": token.tokenId,
                        "amount":price * 100.0,
                        "description": "buy using e-shop",
                        "shipping": [
                            "city": "shippingAddress.City!",
                            "state": "shippingAddress.State!",
                            "zip": "shippingAddress.Zip!",
                            "firstName": "shippingAddress.FirstName!",
                            "lastName": "shippingAddress.LastName!"] ] as [String : Any]
        
            try! request.httpBody = JSONSerialization.data(withJSONObject: body, options: JSONSerialization.WritingOptions())
            //3
            NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: OperationQueue.main) { (response, data, error) -> Void in
                completion(error)
            }
    }
}
