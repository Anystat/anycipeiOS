//
//  ReceptTableViewController.swift
//  Anycipe
//
//  Created by Vitaly on 10.11.16.
//  Copyright © 2016 Vitaly. All rights reserved.
//

import UIKit


class ReceptTableViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {
    
    @IBOutlet weak var sigmentController: UISegmentedControl!
    @IBOutlet var ReceptTable: UITableView!
    
    var recepts = [Recept]()
    var filteredRecepts = [Recept]()
    var shouldShowSearchResults = false
    
    var searchController: UISearchController!

    override func viewDidLoad() {
        super.viewDidLoad()
        createRecepts()
        configureSearchController()
    }

    func createRecepts() {

        recepts.append(Recept(recept: "Мясо", isType: true))
        recepts.append(Recept(recept: "Говядина по мексикански", isType: false))
        recepts.append(Recept(recept: "Шашлык грузинский", isType: false))
        recepts.append(Recept(recept: "Котлета по домашнему", isType: false))
        recepts.append(Recept(recept: "Супы", isType: true))
        recepts.append(Recept(recept: "Грибной", isType: false))
        recepts.append(Recept(recept: "Борщ", isType: false))
        recepts.append(Recept(recept: "Летний легкий", isType: false))
        recepts.append(Recept(recept: "Десерты", isType: true))
        recepts.append(Recept(recept: "Шарлотка", isType: false))
        recepts.append(Recept(recept: "Тирамису", isType: false))

    }
    
    // MARK: - Search Controller
    
    func configureSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = true
        searchController.searchBar.placeholder = "Поиск..."
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        
        ReceptTable.tableHeaderView = searchController.searchBar
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
            shouldShowSearchResults = true
            ReceptTable.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if !shouldShowSearchResults {
            shouldShowSearchResults = true
            ReceptTable.reloadData()
        }
        else {
            shouldShowSearchResults = false
            ReceptTable.reloadData()
        }
        
        searchController.searchBar.resignFirstResponder()
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchString = searchController.searchBar.text
        
        filteredRecepts = recepts.filter({ (findObj) -> Bool in
            let fText: NSString = findObj.recept as NSString
            return (fText.range(of: searchString!, options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound
        })

        ReceptTable.reloadData()
    }

    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if shouldShowSearchResults {
            return filteredRecepts.count
        }
        else {
            return recepts.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        if shouldShowSearchResults {
            if filteredRecepts[indexPath.row].isType {
                cell = tableView.dequeueReusableCell(withIdentifier: "ReceptTypeCell")!
                cell.textLabel?.text = filteredRecepts[indexPath.row].recept
            }
            else {
                cell = tableView.dequeueReusableCell(withIdentifier: "ReceptItemCell")!
                cell.textLabel?.text = "  " + filteredRecepts[indexPath.row].recept
                cell.textLabel?.textColor = UIColor.gray
            }
        }
        else {
            if recepts[indexPath.row].isType {
                cell = tableView.dequeueReusableCell(withIdentifier: "ReceptTypeCell")!
                cell.textLabel?.text = recepts[indexPath.row].recept
            }
            else {
                cell = tableView.dequeueReusableCell(withIdentifier: "ReceptItemCell")!
                cell.textLabel?.text = "  " + recepts[indexPath.row].recept
                cell.textLabel?.textColor = UIColor.gray
            }
        }
        
        return cell
    }
    
    
    
    
    
    


    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
