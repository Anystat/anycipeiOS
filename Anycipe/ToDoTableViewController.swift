//
//  ToDoTableViewController.swift
//  Anycipe
//
//  Created by Vitaly on 09.11.16.
//  Copyright © 2016 Vitaly. All rights reserved.
//

import UIKit
import MGSwipeTableCell
import RealmSwift
import Refresher

class ToDoTableViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {
    
    @IBOutlet var ToDoTable: UITableView!
    
    var lists : Results<ShoppingListItemModel>!
    
    var shouldShowSearchResults = false
    
    var searchController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureRefreshWithAction()
        configureSearchController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        lists = uiRealm.objects(ShoppingListItemModel.self)
        self.ToDoTable.setEditing(false, animated: true)
        reloadTable()
    }
    
    func reloadTable() {
        lists = lists.sorted(byProperty: "isFavorite", ascending: false)
        self.ToDoTable.reloadData()
    }
    
    func configureRefreshWithAction() {
        ToDoTable.addPullToRefreshWithAction {
            OperationQueue().addOperation {
                sleep(2)
                OperationQueue.main.addOperation {
                    self.tableView.stopPullToRefresh()
                }
            }
        }
    }
    
    // MARK: - Search Controller
    func configureSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = true
        searchController.searchBar.placeholder = "Поиск..."
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        
        ToDoTable.tableHeaderView = searchController.searchBar
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        lists = uiRealm.objects(ShoppingListItemModel.self)
        reloadTable()
        print("=======> searchBarTextDidBeginEditing")
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if !shouldShowSearchResults {
            lists = uiRealm.objects(ShoppingListItemModel.self)
            reloadTable()
        }
        //lists = uiRealm.objects(ShoppingListItemModel.self)
        searchController.searchBar.resignFirstResponder()
        print("=======> searchBarCancelButtonClicked")
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchString = searchController.searchBar.text
        if (searchString?.characters.count)! > 1 {
            shouldShowSearchResults = true
            self.lists = lists.filter("name CONTAINS %@", searchString)
            reloadTable()
        }
        
        
        print("=======> updateSearchResults")

        
//            dataArray.filter({ (product) -> Bool in
//            let productText: NSString = product as NSString
//            return (productText.range(of: searchString!, options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound
//            })
        
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("=======> searchBarTextDidEndEditing")
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let listsTasks = lists else {
            return 0
        }
        return listsTasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let list = lists[indexPath.row]
        let cell = MGSwipeTableCell(style: UITableViewCellStyle.value1, reuseIdentifier: "toDoCell")
        var textLabel = list.name

        if list.isFavorite {
            textLabel = "♥️ " + textLabel
        }
        else {
            textLabel = "  " + textLabel
        }
        
        if list.isCheck {
            let atbString = NSMutableAttributedString(string: textLabel)
            atbString.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, atbString.length))
            atbString.addAttribute(NSStrikethroughColorAttributeName, value: UIColor.blue, range: NSMakeRange(0, atbString.length))
            cell.textLabel?.attributedText =  atbString
        }
        else {
            cell.textLabel?.attributedText = nil
            cell.textLabel?.text = textLabel
        }
        
        cell.detailTextLabel!.text = "\(NSString(format: "%.1f", list.quantity)) \(list.unit)"
        
        
        //configure left buttons
        cell.leftButtons = [checkButton(object: list), favButton(object: list)]
        cell.leftSwipeSettings.transition = MGSwipeTransition.clipCenter
        cell.leftExpansion.buttonIndex = 0
        cell.leftExpansion.fillOnTrigger = true
        
        //configure right buttons
        cell.rightButtons = [delButton(object: list), moreButton(object: list)]
        cell.rightSwipeSettings.transition = MGSwipeTransition.clipCenter
        cell.rightExpansion.buttonIndex = 1
        cell.rightExpansion.fillOnTrigger = true
        
        return cell
    }
    
    // MARK: - Buttons
    func checkButton(object: ShoppingListItemModel) -> UIView {
        let button = MGSwipeButton(
            title: "",
            icon: UIImage(named:"check.png"),
            backgroundColor: UIColor.green,
            callback: {
                (sender: MGSwipeTableCell!) -> Bool in
                try! uiRealm.write {
                    uiRealm.create(ShoppingListItemModel.self, value: ["name": object.name, "isCheck": !object.isCheck], update: true)
                }
                self.reloadTable()
                return true
            })
        return button
    }
    
    func favButton(object: ShoppingListItemModel) -> UIView {
        let button = MGSwipeButton(
            title: "",
            icon: UIImage(named:"fav.png"),
            backgroundColor: UIColor.flatMagenta,
            callback: {
                (sender: MGSwipeTableCell!) -> Bool in
                try! uiRealm.write {
                    uiRealm.create(ShoppingListItemModel.self, value: ["name": object.name, "isFavorite": !object.isFavorite], update: true)
                }
                self.reloadTable()
                return true
            })
        return button
    }
    
    func delButton(object: ShoppingListItemModel) -> UIView {
        let button = MGSwipeButton(
            title: "Удалить",
            backgroundColor: UIColor.red,
            callback: {
                (sender: MGSwipeTableCell!) -> Bool in
                try! uiRealm.write{
                    uiRealm.delete(object)
                }
                self.reloadTable()
                return true
        })
        return button
    }
    
    func moreButton(object: ShoppingListItemModel) -> UIView {
        let button = MGSwipeButton(
            title: "Подробнее",
            backgroundColor: UIColor.lightGray,
            callback: {
                (sender: MGSwipeTableCell!) -> Bool in
                    self.showControllerWithMode(object: object)
                return true
        })
        return button
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */


    
    // MARK: - Navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "showDetailToDo" {
//            if let indexPath = tableView.indexPathForSelectedRow {
//                let controller = (segue.destination as! UINavigationController).topViewController as! ToDoDetailViewController
//                
//                controller.list = lists[indexPath.row]
//                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
//                controller.navigationItem.leftItemsSupplementBackButton = true
//            }
//        }
//    }
    
    func showControllerWithMode(object: ShoppingListItemModel) {
        if let pullToRefreshViewControler = self.storyboard?.instantiateViewController(withIdentifier: "ToDoDetailViewController") as? ToDoDetailViewController {
            pullToRefreshViewControler.list = object
            navigationController?.pushViewController(pullToRefreshViewControler, animated: true)
        }
    }


}
