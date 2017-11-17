//
//  CartCell.swift
//  e-shop
//
//  Created by surendra kumar on 11/14/17.
//  Copyright © 2017 weza. All rights reserved.
//

import UIKit

class CartCell: UITableViewCell {
    
    
    @IBOutlet var itemImage: UIImageView!
    @IBOutlet var name: UILabel!
    @IBOutlet var steper: UIStepper!
    @IBOutlet var price: UILabel!
    
    var cartItem : CartItem?{
        didSet{
            updateCell()
        }
    }
   
    @IBAction func steperClicked(_ sender: UIStepper) {
        cartItem?.count = Int(sender.value)
        self.name.text       =  "\(cartItem?.item.name ?? ""): \(cartItem?.count ?? 1)"
        let count = cartItem?.count
        if let price = cartItem?.item.price{
            let effectivePrice = price * Double(count!)
            self.price.text     =  "\(effectivePrice)"
        }
        
        NotificationCenter.default.post(name: NSNotification.Name("step"), object: nil, userInfo: nil)
    }
    
    func updateCell(){
        self.itemImage.image = UIImage(named: (cartItem?.item.name)!)
        self.name.text       =  "\(cartItem?.item.name ?? ""): \(cartItem?.count ?? 1)"
        let count = cartItem?.count
        if let price = cartItem?.item.price{
            let effectivePrice = price * Double(count!)
            self.price.text     =  "\(effectivePrice)"
        }
        
    }
}
