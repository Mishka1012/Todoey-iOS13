//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Mikhail Amshei on 12/7/19.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //loading core data items
        loadCategories()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        //random flat color for Chameleon Framework
        cell.backgroundColor = UIColor.randomFlat()
        cell.textLabel?.text = categories?[indexPath.row].name ?? "NO CATEGORIES"
        return cell
    }
    
    //MARK: - Add Category Action
    
    @IBAction func addCategory(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        //alert view controller
        let alert = UIAlertController(title: "Add New ToDoEy Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            //what will happen once user clicks add item button.
            guard let categoryName = textField.text else {
                fatalError("Unable to get new text item to append")
            }
            let newCategory = Category()
            newCategory.name = categoryName
            self.save(category: newCategory)
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Category"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Table View Delegate
    //segue on click
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //perform a segue here (order is important)
        performSegue(withIdentifier: K.goToItemsSegueIdentifier, sender: self)
        tableView.deselectRow(at: indexPath, animated: false)
    }
    //MARK: - Preparing for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationVC = segue.destination as? ToDoListViewController else {
            fatalError("Wrong destination Triggered.")
        }
        guard let indexPath = tableView.indexPathForSelectedRow else {
            fatalError("No index path selected at segue")
        }
        destinationVC.selectedCategory = categories?[indexPath.row]
        
    }
    //MARK: - Data Manipulation
    func loadCategories() {
        categories = K.realm.objects(Category.self)
        tableView.reloadData()
    }
    func save(category: Category) {
        do {
            try K.realm.write {
                K.realm.add(category)
            }
        } catch {
            fatalError(error.localizedDescription)
        }
        tableView.reloadData()
    }
    //MARK: - DELETE
    override func updateModel(at indexPath: IndexPath) {
        guard let category = self.categories?[indexPath.row] else {
            fatalError("Could not extract category")
        }
        do {
            try K.realm.write {
                K.realm.delete(category.items)
                K.realm.delete(category)
            }
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
