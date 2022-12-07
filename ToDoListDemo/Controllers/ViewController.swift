//
//  ViewController.swift
//  ToDoListDemo
//
//  Created by Macbook on 28/11/22.
//

import UIKit
import RealmSwift

class ViewController: SwipeTableViewController {
    
    var todoItems: Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory: Category? {
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return todoItems?.count ?? 1
        }
   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if  let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error Saving done Status \(error)")
            }
        }
            tableView.reloadData()
            tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addItoms(_ sender: UIBarButtonItem) {
            var textField = UITextField()
        
            let alert = UIAlertController(title: "Add New Itom", message: "", preferredStyle: .alert)
        
           
            let add = UIAlertAction(title: "Add", style: .default) { [self]
                    (action) in
           
                if let currentCategory = self.selectedCategory {
                    do {
                        try realm.write {
                            let newItem = Item()
                            newItem.title = textField.text!
                            currentCategory.items.append(newItem)
                        }
                    } catch {
                        print("Error Saving New Item \(error)")
                    }
                }
                self.tableView.reloadData()
           }
        
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
            alert.addTextField { (alertTextField) in
                alertTextField.placeholder = "create new itom"
                textField = alertTextField
            }
        
            alert.addAction(add)
            alert.addAction(cancel)
        
                present(alert, animated: true, completion: nil)
        }
    
    
  func loadItems() {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
      
        tableView.reloadData()
     
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(item)
                }
            } catch {
                print("Error Saving Status \(error)")
            }
            
        }
    }
}

    


