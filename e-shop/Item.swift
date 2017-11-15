//
//  Item.swift
//  e-shop
//
//  Created by surendra kumar on 11/14/17.
//  Copyright © 2017 weza. All rights reserved.
//

import Foundation

let str = """
As you can in picture this is awesome product, but image in very good because its not in currect size.
You can buy it on discount on some other website but here you will get on awesome price.
"""
struct Item {
    var name : String
    var price : Double  // in Rs
    var description : String
}

let items = [Item(name: "Biryani", price: 234,description:str),
             Item(name: "Boost", price: 291,description:str),
             Item(name: "Butter", price: 231,description:str),
             Item(name: "Chicken", price: 675,description:str),
             Item(name: "Cookies", price: 232,description:str),
             Item(name: "dall", price: 123,description:str),
             Item(name: "Ghee", price: 786,description:str),
             Item(name: "Hen", price: 231,description:str),
             Item(name: "Oats", price: 321,description:str),
             Item(name: "Rice", price: 897,description:str),
             Item(name: "Roti", price: 232,description:str),
             Item(name: "Tea", price: 12,description:str),
             Item(name: "Sugar", price: 34,description:str),
             Item(name: "Corona", price: 43,description:str),
             Item(name: "Breezer", price: 12,description:str),
             Item(name: "Pepsi", price: 56,description:str),
             Item(name: "Tab", price: 87,description:str),
             Item(name: "Mobile", price: 58495,description:str),
             Item(name: "TV", price: 57489,description:str),
             Item(name: "Knife", price: 221,description:str),
             Item(name: "thurmas", price: 346,description:str)
            ]
