//
//  TodoListViewController.swift
//  Todoey
//
//  Created by Vinayak Bhor on 17/06/19.
//  Copyright © 2019 Vinayak Bhor. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    
    
    var itemArray = [Item]()
    //var itemArray = ["Walking","Yoga","Jumping Jack","a","v","n","l","m","f","s"]
    //var itemArrayB = ["Walking","Yoga","Jumping Jack","a","v","n","l","m","f","s","a","v","n","l","m","f","s"]
    
    
    var defaults = UserDefaults.standard
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")
    override func viewDidLoad() {
        super.viewDidLoad()

        print("dataFilePath : \(dataFilePath)")
        
        loadItem()

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
        
        /*Use ternery operator to optimize this code
        if itemArray[indexPath.row].done == true{
            cell.accessoryType = .checkmark
            
        }else{
            cell.accessoryType = .none
            
        }
        */
        return cell
    }
    
    //Mark - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        //Optimize code
        
        let item = itemArray[indexPath.row]
        
        item.done = !item.done
        
        
        /*
         //Instead of writing below three line
         
         if itemArray[indexPath.row].done == false{
         
         self.itemArray[indexPath.row].done = true
         
         }else{
         
         self.itemArray[indexPath.row].done = false
         }
         
         //Write
         let item = itemArray[indexPath.row]
         
         item.done = !item.done
         
        
        */
        
        //self.tableView.reloadData()
        
        self.saveItem()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add New Item
    @IBAction func addNewItemBtnClicked(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todaey Item", message: "", preferredStyle: .alert)
        
        let alertAction =  UIAlertAction(title: "Add New Item", style: .default) {(action) in
            print("Sucess")
            
            print("entered text :\(textField.text!)")
            
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            
            print("Item Array \(self.itemArray)")
            
            //self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            //Save Data using Encoder
            
            
            self.saveItem()
            
        }
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Create New Folder"
            
            textField = alertTextField
            
        }
        
        alert.addAction(alertAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func saveItem(){
        let encoder = PropertyListEncoder()
        
        do {
            
            let data = try encoder.encode(itemArray)
            
            try data.write(to: dataFilePath!)
            
        } catch {
            
            print("Error in Encoding Item \(error)")
            
        }
        
        self.tableView.reloadData()
    }
    
    //Issue: latest added data not loaded
    func loadItem(){
        
        if let  data = try? Data(contentsOf: dataFilePath!){
            
            let decoder = PropertyListDecoder()

            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error decoding")
            }
            
            
        }
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
