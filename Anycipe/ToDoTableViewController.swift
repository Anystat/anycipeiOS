//
//  ToDoTableViewController.swift
//  Anycipe
//
//  Created by Vitaly on 09.11.16.
//  Copyright © 2016 Vitaly. All rights reserved.
//

import UIKit
import MGSwipeTableCell

class ToDoTableViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {
    
    @IBOutlet var ToDoTable: UITableView!
    
    var dataArray = [String]()
    var filteredArray = [String]()
    var shouldShowSearchResults = false
    
    var searchController: UISearchController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ToDoTable.delegate = self
        //ToDoTable.dataSource = self
        loadListOfProducts()
        configureSearchController()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Loads
    
    func loadListOfProducts() {
        // Specify the path to the countries list file.
        let pathToFile = Bundle.main.path(forResource: "products", ofType: "txt")
        
        if let path = pathToFile {
            // Load the file contents as a string.
            let countriesString = try! String(contentsOfFile: path, encoding: String.Encoding.utf8)
            
            // Append the countries from the string to the dataArray array by breaking them using the line change character.
            dataArray = countriesString.components(separatedBy: "\n")
            // Reload the tableview.
            ToDoTable.reloadData()
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
        shouldShowSearchResults = true
        ToDoTable.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if !shouldShowSearchResults {
            shouldShowSearchResults = true
            ToDoTable.reloadData()
        }
        
        searchController.searchBar.resignFirstResponder()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchString = searchController.searchBar.text
        // Filter the data array and get only those countries that match the search text.
        filteredArray = dataArray.filter({ (country) -> Bool in
            let countryText: NSString = country as NSString
            return (countryText.range(of: searchString!, options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound
        })
        
        // Reload the tableview.
        ToDoTable.reloadData()
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if shouldShowSearchResults {
            return filteredArray.count
        }
        else {
            return dataArray.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MGSwipeTableCell(style: UITableViewCellStyle.value1, reuseIdentifier: "toDoCell")
        
        if shouldShowSearchResults {
            cell.textLabel?.text = filteredArray[indexPath.row]
            cell.detailTextLabel!.text = String(arc4random()) + " кг"
        }
        else {
            cell.textLabel?.text = dataArray[indexPath.row]
            cell.detailTextLabel!.text = String(arc4random()) + " кг"
        }

        //cell?.delegate = self //optional
        
        //configure left buttons
        cell.leftButtons = [
                            MGSwipeButton(title: "", icon: UIImage(named:"check.png"), backgroundColor: UIColor.green),
                            MGSwipeButton(title: "", icon: UIImage(named:"fav.png"), backgroundColor: UIColor.blue)
                            ]
        cell.leftSwipeSettings.transition = MGSwipeTransition.clipCenter
        
        //configure right buttons
        cell.rightButtons = [
                            MGSwipeButton(title: "Удалить", backgroundColor: UIColor.red, callback: {
                                (sender: MGSwipeTableCell!) -> Bool in
                                self.dataArray.remove(at: indexPath.row)
                                self.ToDoTable.reloadData()
                                return true
                            }),
                            MGSwipeButton(title: "Подробнее",backgroundColor: UIColor.lightGray)]
        cell.rightSwipeSettings.transition = MGSwipeTransition.clipCenter
        
        return cell
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
