//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Priya Kushte on 17/08/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()

    var categories : Results<Category>? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        loadCategories()
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if let categoryCount = categories?.count,categoryCount>0{
            return categoryCount
        }
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        
        if let categories = categories, categories.count>0 {
            cell.textLabel?.text = categories[indexPath.row].name
        }else {
            
            cell.textLabel?.text = "No categories added yet"
        }
        
        return cell
    }
    
    //MARK: - Data manipulation methods
    
    func save(category: Category) {
        
        do {
            try realm.write {
                realm.add(category)
            }
        }
        catch {
           print("Error saving context \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadCategories() {
     
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
   }
    
    //MARK: - Add new category
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            if let categoryText = textField.text {
                
                let newCategory = Category()
                newCategory.name = categoryText
                
                //self.defaults.setValue(self.itemArray, forKey: "TodoListArray")
                
                self.save(category: newCategory)
            }
        }
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Create New Category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
//            context.delete(categories[indexPath.row])
//            categories.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            //save(category: categories?[indexPath.row])
            
            }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoViewController
        
        if let currentIndexPath = tableView.indexPathForSelectedRow {
            
            destinationVC.selectedCategory = categories?[currentIndexPath.row]
        }
    }
}
