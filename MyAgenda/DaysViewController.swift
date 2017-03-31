//
//  DaysViewController.swift
//  MyAgenda
//
//  Created by Mike Vork on 3/31/17.
//  Copyright © 2017 Mike Vork. All rights reserved.
//

import UIKit

class DaysViewController: UIViewController {
    struct Storyboard {
        static let cellIdentifier = "daysCell"
    }
    
    var daysToShow = 1  // defaults to Today
    
    private var agendaItems = [[AgendaItem]]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        loadAgendaItems()
        self.navigationItem.title = (daysToShow > 1) ? "Next \(daysToShow) Days" : "Today"
        
    }
    
    private func loadAgendaItems() {
        let calendar = NSCalendar.current
        var currentDay = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: Date())  // today
        
        agendaItems.removeAll()
        for _ in 0..<daysToShow {
            let nextDay = calendar.date(byAdding: Calendar.Component.day, value: 1, to: currentDay!)
            let oneDaysItems =  ModelController.sharedInstance.loadAgendaItems(from: currentDay!, to: nextDay!)
            print("oneDaysItems: \(oneDaysItems.count)")  // zap
            agendaItems.append(oneDaysItems)
            
            currentDay = nextDay
        }
        
        print("number of days: \(agendaItems.count)")  // zap
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
                                                 for: indexPath) as! CategoryTVC
        
        cell.agendaItem = agendaItems[indexPath.section][indexPath.row]
        
        return cell
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
