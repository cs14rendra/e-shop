//
//  paymentSummary.swift
//  e-shop
//
//  Created by surendra kumar on 11/16/17.
//  Copyright © 2017 weza. All rights reserved.
//

import UIKit

class paymentSummary: UIViewController {

    @IBOutlet var isSuccessLB: UILabel!
    var isSucees : Bool?
    override func viewDidLoad() {
        super.viewDidLoad()
        if let success = isSucees, success == true{
            self.isSuccessLB.text = "Status : Successfully Paid"
            
        }else{
            self.isSuccessLB.text = "Status : Payment Failed"
        }
    }
    override func loadView() {
        Bundle.main.loadNibNamed("paymentSummary", owner: self, options: nil)
    }
    
    @IBAction func done(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
