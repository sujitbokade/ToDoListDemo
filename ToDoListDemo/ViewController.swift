//
//  ViewController.swift
//  ToDoListDemo
//
//  Created by Macbook on 28/11/22.
//

import UIKit

class ViewController: UITableViewController {
    
    var itemArray = ["Milk","Eggs","Water"]
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let item = defaults.array(forKey: "ToDoListArray") as? [String] {
            itemArray = item
        }
        
    }
     override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark { 
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
   
    @IBAction func addItoms(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Itom", message: "", preferredStyle: .alert)
        
        let add = UIAlertAction(title: "Add", style: .default){
            (action) in
            self.itemArray.append(textField.text!)
            self.defaults.set(self.itemArray, forKey: "ToDoListArray")
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
    
    
        override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            let edit = UIContextualAction(style: .normal, title: "Update") {
                _, _, _ in
                var textField = UITextField()
                
                let alert = UIAlertController(title: "Update Itom", message: "", preferredStyle: .alert)
                
                let update = UIAlertAction(title: "Update", style: .default){
                    (action) in
                    self.itemArray[indexPath.row] = textField.text!
                    self.defaults.set(self.itemArray, forKey: "ToDoListArray")
                    self.tableView.reloadData()
            }
                
                let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                
                alert.addTextField { (alertTextField) in
                    alertTextField.placeholder = self.itemArray[indexPath.row]
                    textField = alertTextField
                    
            }
                
                    alert.addAction(update)
                    alert.addAction(cancel)
                
                self.present(alert, animated: true, completion: nil)
            }
            edit.backgroundColor = .systemMint
            let delete = UIContextualAction(style: .destructive, title: "Delete") {
                _, _, _ in
                self.itemArray.remove(at: indexPath.row)
                self.defaults.set(self.itemArray, forKey: "ToDoListArray")
                self.tableView.reloadData()
            }
            
            let swipeCofiguration = UISwipeActionsConfiguration(actions: [edit, delete])
            return swipeCofiguration
        }
    }

    


