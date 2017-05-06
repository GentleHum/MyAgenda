//
//  DaysTableViewController.swift
//  MyAgenda
//
//  Created by Mike Vork on 3/31/17.
//  Copyright © 2017 Mike Vork. All rights reserved.
//

import UIKit

class DaysTableViewController: AgendaItemTableViewController {
    struct AIStoryboard {
        static let cellIdentifier = "DaysTVC"
        static let detailSegue = "AgendaItemDetailSegue"
    }
    
    var daysToShow = 1  // defaults to Today
    
    private var sectionNames = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")  // zap
        loadSectionData()


    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadSectionData()
        tableView.reloadData()
        self.navigationItem.title = (daysToShow > 1) ? "Next \(daysToShow) Days" : "Today"
    }
    
    private func loadSectionData() {
        print("loadSectionData")  // zap
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
        print("daysToShow: \(daysToShow)")  // zap
        for _ in 0..<daysToShow {
            let nextDay = calendar.date(byAdding: Calendar.Component.day, value: 1, to: currentDay!)
            let oneDaysItems =  ModelController.sharedInstance.loadAgendaItems(from: currentDay!, to: nextDay!)
            print("appending oneDaysItems: \(oneDaysItems.count)")  // zap
            agendaItems.append(oneDaysItems)
            let dateString = AppGlobals.dateFormatter.getString(from: currentDay!, with: "M/d/y")
            sectionNames.append(dateString)
            currentDay = nextDay
        }

    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AIStoryboard.cellIdentifier,
                                                 for: indexPath)
        print("agendaItems count: \(agendaItems.count)")   // zap
        print("agendaItems[0].count: \(agendaItems[0].count)")  // zap
        print("indexPath: \(indexPath)")  // zap
        let agendaItem = agendaItems[indexPath.section][indexPath.row]
        cell.detailTextLabel?.text = agendaItem.category
        cell.textLabel?.text = agendaItem.descriptionText
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "  " + sectionNames[section]
    }
    
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            let itemToDelete = agendaItems[indexPath.row]
//            ModelController.sharedInstance.deleteAgendaItem(itemToDelete)
//            agendaItems.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        }
//    }
    
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
