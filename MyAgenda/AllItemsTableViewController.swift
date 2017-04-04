//
//  AllItemsTableViewController.swift
//  MyAgenda
//
//  Created by Mike Vork on 3/25/17.
//  Copyright © 2017 Mike Vork. All rights reserved.
//

import UIKit

class AllItemsTableViewController: UITableViewController {
    struct Storyboard {
        static let cellIdentifier = "AgendaItemTVC"
        static let detailSegue = "AgendaItemDetailSegue"
        static let detailController = "AgendaItemDetailViewController"
    }
    
    var agendaItems = [AgendaItem]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        self.navigationItem.title = "All items"
        
        // allows swipe to delete
        tableView.allowsMultipleSelection = false
        
        // no empty rows at bottom of table
        tableView.tableFooterView = UIView()
        
//        navigationItem.leftBarButtonItem = editButtonItem
//        navigationItem.leftItemsSupplementBackButton = true

        // no title on the navigation back button
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        // add gesture recognizers
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(recognizer:)))
        longPressGesture.minimumPressDuration = 0.75;
        tableView.gestureRecognizers = [longPressGesture]

    }
    
    private func delete(from view: UITableView, at indexPath: IndexPath) {
        let itemToDelete = agendaItems[indexPath.row]
        ModelController.sharedInstance.deleteAgendaItem(itemToDelete)
        agendaItems.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        tableView.reloadData()
    }
    
    private func showDeleteConfirmAlert(forCellAt indexPath: IndexPath) {
        let itemDescription = agendaItems[indexPath.row].descriptionText ?? ""
        let message = "Delete '" + itemDescription + "'?"
        let alert: UIAlertController = UIAlertController(title: "Please Confirm",
                                                         message: message,
                                                         preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (UIAlertAction) -> Void in
            self.delete(from: self.tableView, at: indexPath)
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil);
    }

    func handleLongPress(recognizer: UILongPressGestureRecognizer) {
        if recognizer.state == .began {
            let point = recognizer.location(in: tableView)
            if let indexPath = tableView.indexPathForRow(at: point) {
                showDeleteConfirmAlert(forCellAt: indexPath)
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        agendaItems = ModelController.sharedInstance.loadAgendaItems()
        tableView.reloadData()
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return agendaItems.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.cellIdentifier, for: indexPath) as! AgendaItemTVC
        
        // Configure the cell...
        cell.agendaItem = agendaItems[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            delete(from: tableView, at: indexPath)
        }
    }
    

    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        if destinationIndexPath.row != sourceIndexPath.row {
            let itemToMove = agendaItems[sourceIndexPath.row]
            agendaItems.insert(itemToMove, at: destinationIndexPath.row)
            agendaItems.remove(at: sourceIndexPath.row)
        }
    }



    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Storyboard.detailSegue {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let agendaItem = agendaItems[indexPath.row]
                let controller = segue.destination as! AgendaItemDetailViewController
                controller.agendaItem = agendaItem
            }
        }
        
    }



}
