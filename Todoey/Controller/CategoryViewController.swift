//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Mikhail Amshei on 12/7/19.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

class CategoryViewController: UITableViewController {
    
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //loading core data items
        loadCategories()
        //clearing items for swipe view
        tableView.rowHeight = 80
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //saving state before exit
//        saveCategories()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: K.TableView.CategoryCellIdentifier, for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        if let category = categories?[indexPath.row] {
            cell.textLabel?.text = category.name
        } else {
            cell.textLabel?.text = "NO CATEGORIES"
        }
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
}
//MARK: - Swipe Cell Kit
extension CategoryViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            //DELETE
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

        // customize the action appearance
        deleteAction.image = UIImage(systemName: "trash.fill")

        return [deleteAction]
    }
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeTableOptions()
        options.expansionStyle = .destructive
        return options
    }
}
