//
//  ViewController.swift
//  ToDoListDemo
//
//  Created by Macbook on 28/11/22.
//

import UIKit

class ViewController: UITableViewController, UISearchBarDelegate {
    
        var itemArray = [Item]()
        
       let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
      let newItem = Item()
        newItem.title = "Apple"
        itemArray.append(newItem)
        
    let newItem2 = Item()
        newItem2.title = "Mango"
        itemArray.append(newItem2)
        
    let newItem3 = Item()
        newItem3.title = "Coconut"
        itemArray.append(newItem3)
        
        loadItems()
        
//        if let items = defaults.array(forKey: "ToDoListArray") as? [Item] {
//            itemArray = items
//        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return itemArray.count
        }
   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
            cell.textLabel?.text = item.title
        
            cell.accessoryType = item.done == true ? .checkmark : .none
                return cell
        }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){

            itemArray[indexPath.row].done = !itemArray[indexPath.row].done
            tableView.reloadData()
        
            tableView.deselectRow(at: indexPath, animated: true)
        }
   
   
    @IBAction func addItoms(_ sender: UIBarButtonItem) {
            var textField = UITextField()
        
            let alert = UIAlertController(title: "Add New Itom", message: "", preferredStyle: .alert)
        
           
        
            let add = UIAlertAction(title: "Add", style: .default) {
                    (action) in
            let newItem = Item()
                newItem.title = textField.text!
                self.itemArray.append(newItem)
                
            let encoder = PropertyListEncoder()
                
                do {
                    let data = try encoder.encode(self.itemArray)
                    try data.write(to: self.dataFilePath!)
                } catch {
                    print("Error Encoding Item Array \(error)")
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
    
    
        override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            
            let edit = UIContextualAction(style: .normal, title: "Update") {
                _, _, _ in
            var textField = UITextField()
                
            let alert = UIAlertController(title: "Update Itom", message: "", preferredStyle: .alert)
            let update = UIAlertAction(title: "Update", style: .default){
                    (action) in
                    let newItem = Item()
                    newItem.title = textField.text!
                    self.itemArray[indexPath.row] = newItem
                    self.tableView.reloadData()
                }
                
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                
                    alert.addTextField { (alertTextField) in
                        alertTextField.placeholder = self.itemArray[indexPath.row].title
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
//                    self.defaults.set(self.itemArray, forKey: "ToDoListArray")
                    self.tableView.reloadData()
                }
            
            let swipeCofiguration = UISwipeActionsConfiguration(actions: [delete, edit])
                    return swipeCofiguration
            }
    
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
            itemArray = try decoder.decode([Item].self, from: data)
        } catch {
            print("Error Decoding Item Array \(error)")
        }
      }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
}

    


