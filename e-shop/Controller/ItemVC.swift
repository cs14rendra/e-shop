//
//  FirstViewController.swift
//  e-shop
//
//  Created by surendra kumar on 11/14/17.
//  Copyright © 2017 weza. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    @IBOutlet var collectionView: UICollectionView!
    let sectionInset = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
    let itemperRow : CGFloat = 3
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.register(UINib(nibName: "ItemCell", bundle:nil) , forCellWithReuseIdentifier: "ItemCell")
    }

}

extension FirstViewController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCell", for: indexPath) as! ItemCell
        let item = items[indexPath.row]
        cell.itemImage.image = UIImage(named: item.name)
        cell.name.text       = item.name
        cell.price.text      = "\(item.price)"
        return cell
    }
    
    
}

extension FirstViewController : UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let nav = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Details") as? UINavigationController
        let vc = nav?.viewControllers.first as! DetailsVC
        vc.item = items[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}

extension FirstViewController : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding = ( itemperRow + 1) * sectionInset.left
        let availablewidth = collectionView.bounds.width - padding
        let widthPerItem : CGFloat = availablewidth / itemperRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInset
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInset.left
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
