//
//  Extentions.swift
//  e-shop
//
//  Created by surendra kumar on 11/16/17.
//  Copyright © 2017 weza. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func Alert(title : String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: false, completion: nil)
    }
}
