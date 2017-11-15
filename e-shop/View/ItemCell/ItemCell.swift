//
//  ItemCell.swift
//  e-shop
//
//  Created by surendra kumar on 11/14/17.
//  Copyright © 2017 weza. All rights reserved.
//

import UIKit

class ItemCell: UICollectionViewCell {
    @IBOutlet var itemImage: UIImageView!
    @IBOutlet var price: UILabel!
    
    @IBOutlet var name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
