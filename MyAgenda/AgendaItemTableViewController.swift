//
//  AgendaItemTableViewController.swift
//  MyAgenda
//
//  Created by Michael Vork on 5/6/17.
//  Copyright © 2017 Mike Vork. All rights reserved.
//

import UIKit

class AgendaItemTableViewController: UITableViewController {
    struct AIStoryboard {
        static let detailSegue = "AgendaItemDetailSegue"
        static let detailController = "AgendaItemDetailViewController"
    }
    
    var agendaItems = [[AgendaItem]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // allows swipe to delete
        tableView.allowsMultipleSelection = false
        
        // no empty rows at bottom of table
        tableView.tableFooterView = UIView()
        tableView.tableHeaderView = UIView()
        tableView.sectionFooterHeight = 0
        tableView.sectionHeaderHeight = 0
        
        // no title on the navigation back button
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        // add gesture recognizers
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(recognizer:)))
        longPressGesture.minimumPressDuration = 0.75;
        tableView.gestureRecognizers = [longPressGesture]
        
    }
    
    private func delete(from view: UITableView, at indexPath: IndexPath) {
        let itemToDelete = agendaItems[indexPath.section][indexPath.row]
        ModelController.sharedInstance.deleteAgendaItem(itemToDelete)
        agendaItems[indexPath.section].remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        tableView.reloadData()
    }
    
    private func showDeleteConfirmAlert(forCellAt indexPath: IndexPath) {
        let itemDescription = agendaItems[indexPath.section][indexPath.row].descriptionText ?? ""
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
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return agendaItems.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return agendaItems[section].count
    }
    
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.cellIdentifier, for: indexPath) as! AgendaItemTVC
//        
//        // Configure the cell...
//        cell.agendaItem = agendaItems[indexPath.row]
//        
//        return cell
//    }
    
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
        if segue.identifier == AIStoryboard.detailSegue {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let agendaItem = agendaItems[indexPath.section][indexPath.row]
                let controller = segue.destination as! AgendaItemDetailViewController
                controller.agendaItem = agendaItem
            }
        }
        
    }
    
    
    
}
