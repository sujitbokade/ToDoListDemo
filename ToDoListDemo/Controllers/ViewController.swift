//
//  ViewController.swift
//  ToDoListDemo
//
//  Created by Macbook on 28/11/22.
//

import UIKit
import CoreData

class ViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))

        loadItems()
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
            save()
            tableView.reloadData()
        
            tableView.deselectRow(at: indexPath, animated: true)
        }
   
   
    @IBAction func addItoms(_ sender: UIBarButtonItem) {
            var textField = UITextField()
        
            let alert = UIAlertController(title: "Add New Itom", message: "", preferredStyle: .alert)
        
           
            let add = UIAlertAction(title: "Add", style: .default) { [self]
                    (action) in
           
                let newItem = Item(context: self.context)
                newItem.done = false
                newItem.title = textField.text!
                self.itemArray.append(newItem)
                save()
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
                
                let update = UIAlertAction(title: "Update", style: .default){ [self]
                    (action) in
                    let newItem = Item(context: self.context)
                    guard let field = textField.text, !field.isEmpty else {
                    return
                }
                    newItem.title = field
                    self.itemArray[indexPath.row] = newItem
                    save()
                    loadItems()
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
           let delete = UIContextualAction(style: .destructive, title: "Delete") { [self]
                        _, _, _ in
                    self.context.delete(self.itemArray[indexPath.row])
                    save()
                    loadItems()
                    self.tableView.reloadData()
                }
            
            let swipeCofiguration = UISwipeActionsConfiguration(actions: [delete, edit])
                    return swipeCofiguration
            }
    
    func save() {
        do {
                try self.context.save()
            } catch {
                print("Error \(error)")
            }
            
            self.tableView.reloadData()
    }
    
    func loadItems() {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        do {
        itemArray =  try context.fetch(request)
        } catch {
            print("Error Fecting Data \(error)")
        }
    }
}

    


