//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController, UISearchBarDelegate {
    
    //selected category
    var selectedCategory: Category? {
        didSet {
//            loadCoreDataItems()
        }
    }
    
    //core data
    var itemArray = [Item]()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //this is too slow, we have to use something else.
        saveCoreDataItems()
    }
    
    //MARK: - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.TableView.cellReuseIdentifier, for: indexPath)
        let item = itemArray[indexPath.row]
//        cell.textLabel?.text = item.title
        //ternary operator
        cell.accessoryType = item.done ? .checkmark : .none
        return cell
    }
    //MARK: - Table View Delegate Method
    //UPDATE
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //toggling the check mark
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        //saving items
        saveCoreDataItems()
        //deselecting highlight on the cells with animation.
        tableView.deselectRow(at: indexPath, animated: true)
        //i'm not sure if we need to reload here
        tableView.reloadData()
    }
    //DELETE
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else {//toggling the check mark
            itemArray[indexPath.row].done = !itemArray[indexPath.row].done
            //saving items
            saveCoreDataItems()
            //i'm not sure if we need to reload here
            tableView.reloadData()
            return
        }
        //DELETE Order Matters.
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
//        tableView.deleteRows(at: [indexPath], with: .fade)
//        saveCoreDataItems()
    }
    //MARK: - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        //alert text field text
        var textField = UITextField()
        //alert view controller
        let alert = UIAlertController(title: "Add New ToDoEy Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once user clicks add item button.
            guard let text = textField.text else {
                fatalError("Unable to get new text item to append to array")
            }
            //core data way
//            let newItem = Item(context: self.context)
//            newItem.title = text
//            newItem.done = false
//            newItem.parentCategory = self.selectedCategory
//            self.itemArray.append(newItem)
//            self.saveCoreDataItems()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    //MARK: - Core Data
    /*
     Object Oriented Database. Can be relational.
     */
    //CREATE
    func saveCoreDataItems() {
        do {
//            try context.save()
        } catch {
            fatalError(error.localizedDescription)
        }
        //reloading the table view to show data
        self.tableView.reloadData()
    }
    //READ Notice the default value
//    func loadCoreDataItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
//        itemArray = CDModel.loadCoreDataItems(with: request, withPredicate: predicate, forCategory: selectedCategory!, forContext: context)
//        tableView.reloadData()
//    }
    //MARK: - SearchBar Delegate
    //delegate is set up with storyboard
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //request
//        let request: NSFetchRequest<Item> = Item.fetchRequest()
//        guard let text = searchBar.text else {
//            fatalError("No Text in search bar!")
//        }
//        //catching an empty text field
//        if text == "" {
//            loadCoreDataItems()
//        } else {
//            //query called predicate
//            let predicate = NSPredicate(format: "title CONTAINS[cd] %@", text)
//            //sorting results
//            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//            //fetching
//            loadCoreDataItems(with: request, predicate: predicate)
//        }
        //hiding keyboard
        searchBar.resignFirstResponder()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard searchBar.text?.count == 0 else {
            return
        }
//        loadCoreDataItems()
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
    }
}

