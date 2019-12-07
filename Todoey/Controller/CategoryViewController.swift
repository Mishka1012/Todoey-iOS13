//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Mikhail Amshei on 12/7/19.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categories = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //loading core data items
        loadCategories()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.TableView.CategoryCellIdentifier, for: indexPath)
        let category = categories[indexPath.row]
        cell.textLabel?.text = category.name
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
            let newCategory = Category(context: self.context)
            newCategory.name = categoryName
            self.categories.append(newCategory)
            self.saveCategories()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Category"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Table View Delegate
    /*
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //delete category here
            context.delete(categories[indexPath.row])
            categories.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            saveCategories()
        }
    }
     */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //perform a segue here
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
        destinationVC.selectedCategory = categories[indexPath.row]
        
    }
    //MARK: - Data Manipulation
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categories = try context.fetch(request)
        } catch {
            fatalError(error.localizedDescription)
        }
        tableView.reloadData()
    }
    func saveCategories() {
        do {
            try context.save()
        } catch {
            fatalError(error.localizedDescription)
        }
        tableView.reloadData()
    }
}
