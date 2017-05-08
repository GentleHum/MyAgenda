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
        
        cellIdentifier = Storyboard.itemCellIdentifier
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        agendaItems.removeAll()
        agendaItems.append(ModelController.sharedInstance.loadAgendaItems(matching: categoryName))
        tableView.reloadData()
        self.navigationItem.title = categoryName
    }
   
    
    // MARK: Navigation
   
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
