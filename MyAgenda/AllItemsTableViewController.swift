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
    
    private var categoryNames = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "All items"
        self.cellIdentifier = Storyboard.cellIdentifier
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        categoryNames = ModelController.sharedInstance.getCategoryNames()
        agendaItems.removeAll()
        
        for categoryName in categoryNames {
            agendaItems.append(ModelController.sharedInstance.loadAgendaItems(matching: categoryName))
        }
        tableView.reloadData()
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "  " + categoryNames[section]
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
