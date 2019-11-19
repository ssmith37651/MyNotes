//
//  MyNotesTableViewController.swift
//  MyNotes
//
//  Created by Smith, Stephen Christopher on 11/19/19.
//  Copyright © 2019 Smith, Stephen Christopher. All rights reserved.
//

import UIKit
import CoreData

class MyNotesTableViewController: UITableViewController {
    
    // create a reference to a Context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var notes = [Note]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadNotes()

        self.tableView.rowHeight = 84.0
    }
    
    // fetch Notes from CoreData
    func loadNotes() {
        
        // create an instance of a FetchRequest so that
        // ShoppingLists can be fetched from CoreData
        let request: NSFetchRequest<Note> = Note.fetchRequest()
        
        do {
            // use context to execute a fetch request to fetch ShoppingLists from CoreData
            // store the fetched ShoppingLists in our array
            notes = try context.fetch(request)
        } catch {
            print("Error fetching Notes from CoreData!")
        }
        
        // reload the fetched data in the tableViewController
        tableView.reloadData()
    }
    
    // save Note entities into CoreData
    func saveNotes() {
        do{
            // use context to save ShoppingLists into CoreData
            try context.save()
        } catch {
            print("Error saving Notes to CoreData!")
        }
        
        // reload the data in the Table View controller
        tableView.reloadData()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        // declate Text Field Variables for the input of the name, store, and date
        var titleTextField = UITextField()
        var typeTextField = UITextField()
        
        // create an Alert Controller
        let alert = UIAlertController(title: "My Notes", message: "", preferredStyle: .alert)
        
        // defone an action that will occur when the Add List Button is pushed
        let action = UIAlertAction(title: "Create", style: .default, handler: { (action) in
            
            // create an instance of a Note entity
            let newNote = Note(context: self.context)
            
            // get name, store, and date input by user and store them in Note entity
            newNote.title = titleTextField.text!
            newNote.type = typeTextField.text!
            let date = Date()
            let format = DateFormatter()
            format.dateFormat = "yyyy-MM-dd"
            let formattedDate = format.string(from: date)
            newNote.date = formattedDate
            
            // add ShoppingList entity into array
            self.notes.append(newNote)
            
            // save ShoppingLists into CoreData
            self.saveNotes()
        })
        
        // disavle the action that will occur when the Add List button is pushed
        action.isEnabled = false
        
        // define an action that will occur when the cancel button is pushed
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (cancelAction) in
            
        })
        
        // add actions into Alert Controller
        alert.addAction(action)
        alert.addAction(cancelAction)
        
        // add the Text Fields into the Alert Controller
        alert.addTextField(configurationHandler: { (field) in
            titleTextField = field
            titleTextField.placeholder = "Enter Title"
            titleTextField.addTarget(self, action: #selector((self.alertTextFieldDidChange)), for: .editingChanged)
        })
        alert.addTextField(configurationHandler: { (field) in
            typeTextField = field
            typeTextField.placeholder = "Enter Type"
            typeTextField.addTarget(self, action: #selector((self.alertTextFieldDidChange)), for: .editingChanged)
        })
        
        // display the Alert Controller
        present(alert, animated: true, completion: nil)
    }
    
    @objc func alertTextFieldDidChange (){
    
            // get a reference to the Alert Controller
            let alertController = self.presentedViewController as! UIAlertController
    
            // get a reference to the Action that allows the user to add a ShoppingList
            let action = alertController.actions[0]
    
            // get a reference to the text in the Text Fields
            if let title = alertController.textFields![0].text, let type = alertController.textFields![1].text {
        
            // trim white space from the text
            let trimmedTitle = title.trimmingCharacters(in: .whitespaces)
            let trimmedType = type.trimmingCharacters(in: .whitespaces)
        
            // check if the trimmed text isn't empty and if it isn't, enable the action that allows the user to add a ShoppingList
            if (!trimmedTitle.isEmpty && !trimmedType.isEmpty){
                action.isEnabled = true
                }
            }
        
        }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return the number of rows
        return notes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyNotesCell", for: indexPath)

        // Configure the cell...
        
        let note = notes[indexPath.row]
        
        cell.textLabel?.text = note.title!
        cell.detailTextLabel!.numberOfLines = 0
        cell.detailTextLabel?.text = "Type: " + note.type! + "\nCreated: " + note.date!

        return cell
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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
