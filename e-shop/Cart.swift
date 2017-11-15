//
//  Cart.swift
//  e-shop
//
//  Created by surendra kumar on 11/14/17.
//  Copyright © 2017 weza. All rights reserved.
//

import Foundation

class CartItem {
    var item : Item
    var count : Int
    init(item :Item,count : Int) {
        self.item = item
        self.count = count
    }
}

var cartItems = [CartItem]()
