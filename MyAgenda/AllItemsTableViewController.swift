//
//  AllItemsTableViewController.swift
//  MyAgenda
//
//  Created by Mike Vork on 3/25/17.
//  Copyright © 2017 Mike Vork. All rights reserved.
//

import UIKit

class AllItemsTableViewController: AgendaItemTableViewController {
    struct Storyboard {
        static let cellIdentifier = "AgendaItemTVC"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "All items"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        agendaItems.removeAll()
        agendaItems.append(ModelController.sharedInstance.loadAgendaItems())
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.cellIdentifier, for: indexPath) as! AgendaItemTableViewCell
    
        
        // Configure the cell...
        cell.agendaItem = agendaItems[indexPath.section][indexPath.row]
        
        return cell
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
