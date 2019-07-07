//
//  TodoListViewController.swift
//  Todoey
//
//  Created by Vinayak Bhor on 17/06/19.
//  Copyright © 2019 Vinayak Bhor. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    
    
    var itemArray = [Item]()
    var defaults = UserDefaults.standard
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    // UIApplication.shared.delegate is Singleton object
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedCategory : Category?{
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("dataFilePath : \(dataFilePath)")
        loadItems()
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return itemArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        

        // Configure the cell...
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItem", for: indexPath)
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        //value = condition ? valueIfTrue : valueIfFalse
        cell.accessoryType = item.done ? .checkmark : .none
        
       
        return cell
    }
    
    //Mark - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        //Delete operation
        //context.delete(itemArray[indexPath.row])
        //itemArray.remove(at:indexPath.row)
        
        //Updaing operation
        //Optimize code
        let item = itemArray[indexPath.row]
        item.done = !item.done
        saveData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add New Item
    @IBAction func addNewItemBtnClicked(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todaey Item", message: "", preferredStyle: .alert)
        
        let alertAction =  UIAlertAction(title: "Add New Item", style: .default) {(action) in
            print("Sucess")
            
            print("entered text :\(textField.text!)")
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            
            print("Item Array \(self.itemArray)")
            self.saveData()
            
        }
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Create New Folder"
            
            textField = alertTextField
            
        }
        
        alert.addAction(alertAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    

    //MARK:- Create Operation
    func saveData(){
        
        do{
            try context.save()
            
        }catch{
            
            print("Error in While Saving \(error)")
        }
        self.tableView.reloadData()
    }
    
    //MARK:- Read Operation
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(),predicate : NSPredicate? = nil){
        
        //let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        
        if let additionalPredicate = predicate{
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,additionalPredicate])
        }else{
           request.predicate = categoryPredicate
        }
        
        
        do{
            
            itemArray = try context.fetch(request)
            
        }catch{
            print("Error While Fetching \(error)")
        }
        
    }
}

//MARK: - Search Bar Method
extension TodoListViewController : UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        //cd for non-case sensetive
        //let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        //let sortDescripter = NSSortDescriptor(key: "title", ascending: true)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
//        do{
//
//            itemArray = try context.fetch(request)
//
//        }catch{
//            print("Error While Fetching \(error)")
//        }
        
        loadItems(with: request)
        tableView.reloadData()
        
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0{
         loadItems()
            
            DispatchQueue.main.async {
                
                searchBar.resignFirstResponder()
            }
        }
    }
    

}
