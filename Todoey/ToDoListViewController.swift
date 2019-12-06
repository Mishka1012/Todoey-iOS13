//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    var itemArray = ["Find Mike", "Buy Eggos", "Destroy Demorgon"]
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        itemArray = defaults.array(forKey: "TodoListArray") as? [String] ?? itemArray
        //It is not good to keep arrays in user defaults since it will make user loading app really slow.  It's not a databse so it should not be used as such.
    }
    
    //MARK: - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
    //MARK: - Table View Delegate Method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //deselecting highlight on the cells with animation.
        tableView.deselectRow(at: indexPath, animated: true)
        //cell Reference
        guard let cell = tableView.cellForRow(at: indexPath) else {
            print("Unable to find cell")
            return
        }
        //selecting and deselecting the checkmark accordingly
        if cell.accessoryType == .checkmark {
            cell.accessoryType = .none
        } else {
            cell.accessoryType = .checkmark
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
                //todo: prevent the default dimiss action
                print("Unable to get new text item to append to array")
                return
            }
            //changing our data source
            self.itemArray.append(text)
            //save array to user defaults
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
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
    
}

