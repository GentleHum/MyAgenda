//
//  CategoryViewController.swift
//  MyAgenda
//
//  Created by Mike Vork on 3/28/17.
//  Copyright © 2017 Mike Vork. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    struct Storyboard {
        static let itemCellIdentifier = "CategoryTVC"
        static let detailSegue = "AgendaItemDetailSegue"
    }

    @IBOutlet weak var tableView: UITableView!
    
    private var agendaItems = [AgendaItem]()
    
    var categoryName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        // empty rows at bottom of table
        tableView.tableFooterView = UIView()
        
        // allows swipe to delete
        tableView.allowsMultipleSelection = false
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        agendaItems = ModelController.sharedInstance.loadAgendaItems(matching: categoryName)
        tableView.reloadData()
        self.navigationItem.title = categoryName
    }
   
    
    // MARK: Table view data source methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return agendaItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.itemCellIdentifier,
                                                 for: indexPath) as! CategoryTVC
        
        cell.agendaItem = agendaItems[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let itemToDelete = agendaItems[indexPath.row]
            ModelController.sharedInstance.deleteAgendaItem(itemToDelete)
            agendaItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
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
