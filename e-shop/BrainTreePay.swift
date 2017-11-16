//
//  BrainTreePay.swift
//  e-shop
//
//  Created by surendra kumar on 11/16/17.
//  Copyright © 2017 weza. All rights reserved.
//

import Foundation
import Braintree

class BraintreePay {
    
    func getClientToken(completion: @escaping (String?)->()){
        
        let url = URL(string: "http://0.0.0.0:5000/client_token")
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request){
            data, response, error in
            guard error == nil else {
                completion(nil)
                return
            }
            let token = String(data: data!, encoding: .utf8)
            DispatchQueue.main.async {
                completion(token)
            }
        }.resume()
        
    }
    
    func makeFinalPayment(nonce : String,price : Double,completion:@escaping (Error?)->()){
        let paymentURL = URL(string: "http://0.0.0.0:5000/checkout")
        var request = URLRequest(url: paymentURL!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let body = ["payment_method_nonce":nonce,
                    "amount": String(price)]         
        try! request.httpBody = JSONSerialization.data(withJSONObject: body, options: JSONSerialization.WritingOptions())
        
        
        URLSession.shared.dataTask(with: request) { (data, response, error) -> Void in
            completion(error)
            }.resume()
    }
}
