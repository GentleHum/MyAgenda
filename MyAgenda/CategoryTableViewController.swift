//
//  CategoryTableViewController.swift
//  MyAgenda
//
//  Created by Mike Vork on 3/28/17.
//  Copyright © 2017 Mike Vork. All rights reserved.
//

import UIKit

class CategoryTableViewController: AgendaItemTableViewController {
    struct Storyboard {
        static let itemCellIdentifier = "CategoryTVC"
        static let detailSegue = "AgendaItemDetailSegue"
    }
    
    var categoryName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        agendaItems.removeAll()
        agendaItems.append(ModelController.sharedInstance.loadAgendaItems(matching: categoryName))
        tableView.reloadData()
        self.navigationItem.title = categoryName
    }
   
    
    // MARK: Table view data source methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.itemCellIdentifier,
                                                 for: indexPath) as! CategoryTableViewCell
        
        cell.agendaItem = agendaItems[indexPath.section][indexPath.row]
        
        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Storyboard.detailSegue {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let agendaItem = agendaItems[indexPath.section][indexPath.row]
                let controller = segue.destination as! AgendaItemDetailViewController
                controller.agendaItem = agendaItem
            }
        }
        
    }
    
    

}
