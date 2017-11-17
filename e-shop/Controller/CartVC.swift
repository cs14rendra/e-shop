//
//  SecondViewController.swift
//  e-shop
//
//  Created by surendra kumar on 11/14/17.
//  Copyright © 2017 weza. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var placeOrder: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.tableView.register(UINib(nibName: "CartCell", bundle:nil), forCellReuseIdentifier: "CartCell")
        NotificationCenter.default.addObserver(self, selector: #selector(SecondViewController.stepperClicked), name: NSNotification.Name("step"), object: nil)
    }
    
    @objc func stepperClicked(){
        var totalPrice = 0.0
        for item in cartItems {
            let price = item.item.price * Double(item.count)
            totalPrice = totalPrice + price
        }
        if totalPrice > 0.0 {
           self.placeOrder.isEnabled = true
        }else{
            self.placeOrder.isEnabled = false
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
        self.placeOrder.isEnabled = false
        if cartItems.count > 0 {
            self.placeOrder.isEnabled = true
        }
        
    }

    @IBAction func placeOrder(_ sender: Any) {
        let controller: UIViewController = OrderVC()
        self.present(controller, animated: true, completion: nil)
    }
}

extension SecondViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartItems.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! CartCell
        let item = cartItems[indexPath.row]
        cell.selectionStyle = .none
        cell.cartItem = item
        return cell
    }
}

extension SecondViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 112
    }
}

