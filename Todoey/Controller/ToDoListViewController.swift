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
        ListItem("Find Mike", checked: false),
        ListItem("Buy Eggos", checked: false),
        ListItem("Destroy Demorgon", checked: false)
    ]
    //user defaults
    let defaults = UserDefaults.standard
    //nscoder
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(K.itemsPlistFileName)

    override func viewDidLoad() {
        super.viewDidLoad()
        loadNSCoderData()
        // Do any additional setup after loading the view.
        //user defaults is not the right application for this
        //extractArrayFromUserDefaults()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //this is too slow, we have to use something else.
        //saveArrayToUserDefaults()
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
        //ternary operator
        cell.accessoryType = item.check ? .checkmark : .none
        return cell
    }
    //MARK: - Table View Delegate Method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //toggling the check mark
        itemArray[indexPath.row].check = !itemArray[indexPath.row].check
        //deselecting highlight on the cells with animation.
        tableView.deselectRow(at: indexPath, animated: true)
        //i'm not sure if we need to reload here
        tableView.reloadData()
        //saving nscoder data
        saveNSCoderData()
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
            self.itemArray.append(ListItem(text, checked: false))
            //reloading the table view to show data
            self.tableView.reloadData()
            //saving nscoder data
            self.saveNSCoderData()
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
    
    //MARK: - NSCoder A different method for savind data
    /*
     SandBoxing concept: Each app can only access its own files and folders.
     Data also gets synched to iCloud
     Apps also can't infect the operating system.
     JailBreak is the only way to bypass this.
     Having separate files using nscoder helps reduce the loading times for reading and writing for the data.
     */
    func loadNSCoderData() {
        guard let data = try? Data(contentsOf: dataFilePath!) else {
            print("Unable to read data from file")
            return
        }
        let decoder = PropertyListDecoder()
        do {
            itemArray = try decoder.decode([ListItem].self, from: data)
        } catch {
            print(error.localizedDescription)
        }
    }
    func saveNSCoderData() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(self.itemArray)
            try data.write(to: self.dataFilePath!)
        } catch {
            print(error.localizedDescription)
            fatalError()
        }
    }
    
    //MARK: - User Defaults is a dictionary
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
        itemArray = dataArray.map({ (data) -> ListItem in
            return ListItem(data: data)
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

