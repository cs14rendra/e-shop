//
//  DetailsVC.swift
//  e-shop
//
//  Created by surendra kumar on 11/14/17.
//  Copyright © 2017 weza. All rights reserved.
//

import UIKit

class DetailsVC: UIViewController {

    @IBOutlet var bt: UIButton!
    @IBOutlet var itemLB: UILabel!
    @IBOutlet var Itemimage: UIImageView!
    var item : Item?
    override func viewDidLoad() {
        super.viewDidLoad()
        updateVC()
        if cartItems.contains(where: {$0.item.name ==  item?.name }){
            bt.setTitle("Added to Cart", for: .normal)
            bt.isEnabled = false
        }
    }

    @IBAction func addToCart(_ sender: Any) {
        let cartitem = CartItem(item: self.item!, count: 1)
        cartItems.append(cartitem)
        let bt = sender as! UIButton
        bt.setTitle("Added to Cart", for: .normal)
        bt.isEnabled = false
    }
    
    func updateVC(){
        self.itemLB.text = item?.description
        self.Itemimage.image = UIImage(named: (item?.name)!)
    }
}
