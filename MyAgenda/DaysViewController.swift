//
//  DaysViewController.swift
//  MyAgenda
//
//  Created by Mike Vork on 3/31/17.
//  Copyright © 2017 Mike Vork. All rights reserved.
//

import UIKit

class DaysViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    struct Storyboard {
        static let cellIdentifier = "DaysTVC"
    }
    
    var daysToShow = 1  // defaults to Today
    
    private var agendaItems = [[AgendaItem]]()
    private var sectionNames = [String]()

    @IBOutlet private weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // eliminate empty rows at bottom of table
        tableView.tableFooterView = UIView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.delegate = self
        tableView.dataSource = self

        loadSectionData()
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
            sectionNames.append(getFormattedDate(currentDay!))
            currentDay = nextDay
        }

    }
    
    
    private func getFormattedDate(_ dateToFormat: Date) -> String {
        let dateFormatter = AppGlobals.dateFormatter
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let currDateString = dateFormatter.string(from: dateToFormat)
        return currDateString
    }
    
    // MARK: Table view data source methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return agendaItems.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return agendaItems[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.cellIdentifier,
                                                 for: indexPath)
        
        let agendaItem = agendaItems[indexPath.section][indexPath.row]
        cell.detailTextLabel?.text = agendaItem.category
        cell.textLabel?.text = agendaItem.descriptionText
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionNames[section]
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            let itemToDelete = agendaItems[indexPath.row]
//            ModelController.sharedInstance.deleteAgendaItem(itemToDelete)
//            agendaItems.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        }
//    }
    

}
