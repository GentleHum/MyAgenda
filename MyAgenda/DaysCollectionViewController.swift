//
//  DaysCollectionViewController.swift
//  MyAgenda
//
//  Created by Michael Vork on 5/24/17.
//  Copyright © 2017 Mike Vork. All rights reserved.
//

import UIKit

class DaysCollectionViewController: AgendaItemCollectionViewController {
    
    var daysToShow = 1      // defaults to Today
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadSectionData()
        self.navigationItem.title = (daysToShow > 1) ? "Next \(daysToShow) Days" : "Today"
    }
    
    private func loadSectionData() {
        // clear the section data
        agendaItems.removeAll()
        sectionNames.removeAll()
        
        var currentDay = NSCalendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())  // today
        
        // load overdue items
        let backDate = 10000.days.ago(from: currentDay!)
        let overdueItems = ModelController.sharedInstance.loadAgendaItems(from: backDate!, to: currentDay!)
        if overdueItems.count > 0 {
            sectionNames.append("Overdue")
            agendaItems.append(overdueItems)
        }
        
        // load daily items
        for _ in 0..<daysToShow {
            let nextDay = 1.days.from(date: currentDay!)
            let oneDaysItems =  ModelController.sharedInstance.loadAgendaItems(from: currentDay!, to: nextDay!)
            agendaItems.append(oneDaysItems)
            let dateString = AppGlobals.dateFormatter.getString(from: currentDay!, with: "M/d/y")
            sectionNames.append(dateString)
            currentDay = nextDay
        }
        
    }

    
    

}
