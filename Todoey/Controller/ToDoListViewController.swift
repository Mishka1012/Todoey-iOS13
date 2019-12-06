//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    var itemArray = [
        ToDoItem("Find Mike", checked: false),
        ToDoItem("Buy Eggos", checked: false),
        ToDoItem("Destroy Demorgon", checked: false)
    ]
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        extractArrayFromUserDefaults()
    }
    
    //MARK: - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellReuseIdentifier, for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.text
        if item.check {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    //MARK: - Table View Delegate Method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //toggling the check mark
        itemArray[indexPath.row].check = !itemArray[indexPath.row].check
        //saving the itemArray to user defaults
        saveArrayToUserDefaults()
        //deselecting highlight on the cells with animation.
        tableView.deselectRow(at: indexPath, animated: true)
        //i'm not sure if we need to reload here
        tableView.reloadData()
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
            self.itemArray.append(ToDoItem(text, checked: false))
            //save array to user defaults
            self.saveArrayToUserDefaults()
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
    //MARK: - User Defaults
    func saveArrayToUserDefaults() {
        let dataArray = itemArray.map { (item) -> Data in
            guard let safeData = item.data else {
                print("Unable to safely extract data from item")
                fatalError()
            }
            return safeData
        }
        defaults.set(dataArray, forKey: K.defaultArrayKey)
    }
    func extractArrayFromUserDefaults() {
        guard let dataArray = defaults.array(forKey: K.defaultArrayKey) as? [Data] else {
            print("Can't extract data array from user defaults.")
            return
        }
        itemArray = dataArray.map({ (data) -> ToDoItem in
            return ToDoItem(data: data)
        })
        //It is not good to keep arrays in user defaults since it will make user loading app really slow.  It's not a databse so it should not be used as such.
        /*Sigletons Notes
         singletons don't matter how many references are made the original gets changed with the reference nomatter who is calling the object.
         class UserDefaults {
            standard = UserDefaults()//Roughly points to the same plist in bundle
         }
         this makes this object quite persistent nomatter the instance references I can make from various files.
         */
    }
}

