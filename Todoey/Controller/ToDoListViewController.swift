//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class ToDoListViewController: SwipeTableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    //selected category
    var selectedCategory: Category? {
        didSet {
            loadItems()
            guard let color = UIColor(hexString: self.selectedCategory!.color) else {
                fatalError("Unable to extract color for bar")
            }
            let contrast = UIColor(contrastingBlackOrWhiteColorOn: color, isFlat: true)
            DispatchQueue.main.async {
                self.navigationController?.navigationBar.backgroundColor = color
                self.navigationController?.navigationBar.barTintColor = contrast
                self.tableView.backgroundColor = color
                //search text field.
                self.searchBar.barTintColor = color.darken(byPercentage: 0.1)
                self.searchBar.searchTextField.backgroundColor = contrast
                self.searchBar.searchTextField.textColor = color
                //setting title text to be the same as category name
                self.navigationItem.title = self.selectedCategory?.name
            }
        }
    }
    
    //core data
    var toDoItems: Results<Item>?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    //MARK: - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        let item = toDoItems?[indexPath.row]
        cell.textLabel?.text = item?.name ?? "NO ITEMS YET"
        //ternary operator
        cell.accessoryType = item?.done ?? false ? .checkmark : .none
        //color for Chameleon Framework
        guard let category = selectedCategory else {
            fatalError("Could not find category for bg color")
        }
        let baseColor = UIColor(hexString: category.color)
        let percentage = CGFloat(indexPath.row) / CGFloat(toDoItems?.count ?? 1)
        cell.backgroundColor = baseColor?.lighten(byPercentage: percentage)
        cell.textLabel?.textColor = UIColor(contrastingBlackOrWhiteColorOn:cell.backgroundColor!, isFlat:true)
        return cell
    }
    //MARK: - Table View Delegate Method
    //UPDATE
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = toDoItems?[indexPath.row] else {
            fatalError("Unable to fetch item for row")
        }
        do {
            try K.realm.write {
                item.done = !item.done
            }
        } catch {
            fatalError(error.localizedDescription)
        }
        //deselecting highlight on the cells with animation.
        tableView.deselectRow(at: indexPath, animated: true)
        //i'm not sure if we need to reload here
        tableView.reloadData()
    }
    //DELETE
    override func updateModel(at indexPath: IndexPath) {
        guard let item = self.toDoItems?[indexPath.row] else {
            fatalError("Could not extract item")
        }
        do {
            try K.realm.write {
                K.realm.delete(item)
            }
        } catch {
            fatalError(error.localizedDescription)
        }
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
            guard let parentCategory = self.selectedCategory else {
                fatalError("Missing selected category")
            }
            //CREATE
            do {
                try K.realm.write {
                    let newItem = Item()
                    newItem.name = text
                    newItem.dateCreated = Date()
                    parentCategory.items.append(newItem)
                    K.realm.add(newItem)
                }
            } catch {
                fatalError(error.localizedDescription)
            }
            //reloading the table view to show data
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    //MARK: - Realm
    /*
     Object Oriented Database. Can be relational.
     */
    //READ Notice the default value
    func loadItems() {
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }
    //MARK: - SearchBar Delegate
    //delegate is set up with storyboard
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else {
            fatalError("No Text in search bar!")
        }
        //catching an empty text field
        if text == "" {
            loadItems()
        } else {
            toDoItems = toDoItems?.filter("name CONTAINS[cd] %@", text).sorted(byKeyPath: "dateCreated", ascending: true)
            tableView.reloadData()
        }
        //hiding keyboard
        searchBar.resignFirstResponder()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard searchBar.text?.count == 0 else {
            return
        }
        loadItems()
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
    }
}

