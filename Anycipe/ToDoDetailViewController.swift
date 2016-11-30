//
//  ToDoDetailViewController.swift
//  Anycipe
//
//  Created by Vitaly on 23.11.16.
//  Copyright © 2016 Vitaly. All rights reserved.
//

import UIKit
import Refresher

class ToDoDetailViewController: UIViewController {
    
    var list = ShoppingListItemModel()
    
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productQuantity: UILabel!
    @IBOutlet weak var productUnit: UILabel!
    @IBOutlet weak var productFavorit: UILabel!
    @IBOutlet weak var productCheck: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let color1 = UIColor.flatCoffee.cgColor
        let color2 = UIColor.flatCoffeeDark.cgColor
        let color3 = UIColor.white.cgColor
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [color1, color2, color3]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        
        productName.text = list.name
        productQuantity.text = "Количество: \(NSString(format: "%.1f", list.quantity))"
        productUnit.text = "\(list.unit)"
        if list.isFavorite {
            productFavorit.text = "♥️"
        }
        else {
            productFavorit.text = ""
        }
        
        
        tableView.addPullToRefreshWithAction {
            OperationQueue().addOperation {
                sleep(2)
                OperationQueue.main.addOperation {
                    self.tableView.stopPullToRefresh()
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.startPullToRefresh()
    }
    
    func tableView(_ tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    func tableView(_ tableView: UITableView!, cellForRowAtIndexPath indexPath: IndexPath!) -> UITableViewCell! {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "CellProductDetail")
        cell.textLabel?.text = "Рецепт " + String(indexPath.row)
//        if indexPath.row == 0 {
//            cell.textLabel?.text = "Рецепты по продукту " + list.name
//        }
//        else {
//            cell.textLabel?.text = "Row " + String(indexPath.row)
//        }
        return cell
    }
}
