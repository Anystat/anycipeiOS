//
//  ToDoDetailViewController.swift
//  Anycipe
//
//  Created by Vitaly on 23.11.16.
//  Copyright © 2016 Vitaly. All rights reserved.
//

import UIKit

class ToDoDetailViewController: UIViewController {
    
    var list = ShoppingListItemModel()
    
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productQuantity: UILabel!
    @IBOutlet weak var productUnit: UILabel!
    
    
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
        productQuantity.text = "\(list.quantity)"
        productUnit.text = "\(list.unit)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
