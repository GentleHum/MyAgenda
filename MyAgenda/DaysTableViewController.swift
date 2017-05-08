//
//  DaysTableViewController.swift
//  MyAgenda
//
//  Created by Mike Vork on 3/31/17.
//  Copyright © 2017 Mike Vork. All rights reserved.
//

import UIKit

class DaysTableViewController: AgendaItemTableViewController {
    struct Storyboard {
        static let cellIdentifier = "DaysTVC"
        static let detailSegue = "AgendaItemDetailSegue"
    }
    
    var daysToShow = 1  // defaults to Today
    
    private var sectionNames = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cellIdentifier = Storyboard.cellIdentifier
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadSectionData()
        tableView.reloadData()
        self.navigationItem.title = (daysToShow > 1) ? "Next \(daysToShow) Days" : "Today"
    }
    
    private func loadSectionData() {
        // clear the section data
        agendaItems.removeAll()
        sectionNames.removeAll()

        let calendar = NSCalendar.current
        var currentDay = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: Date())  // today
        
        // load overdue items
        let backDate = calendar.date(byAdding: Calendar.Component.day,
                                     value: -10000, to: currentDay!)  // a long time ago
        let overdueItems = ModelController.sharedInstance.loadAgendaItems(from: backDate!, to: currentDay!)
        if overdueItems.count > 0 {
            sectionNames.append("Overdue")
            agendaItems.append(overdueItems)
        }

        // load daily items
        for _ in 0..<daysToShow {
            let nextDay = calendar.date(byAdding: Calendar.Component.day, value: 1, to: currentDay!)
            let oneDaysItems =  ModelController.sharedInstance.loadAgendaItems(from: currentDay!, to: nextDay!)
            agendaItems.append(oneDaysItems)
            let dateString = AppGlobals.dateFormatter.getString(from: currentDay!, with: "M/d/y")
            sectionNames.append(dateString)
            currentDay = nextDay
        }

    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "  " + sectionNames[section]
    }
    
    
    // MARK: - Navigation
    
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
