//
//  CategoryTVC.swift
//  MyAgenda
//
//  Created by Mike Vork on 3/28/17.
//  Copyright © 2017 Mike Vork. All rights reserved.
//

import UIKit

class CategoryTVC: UITableViewCell {

    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var itemNameLabel: UILabel!
    
    
    var agendaItem: AgendaItem? {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        // load new information from our item (if any)
        if itemNameLabel != nil {  // verify outlets are configured
            if let item = self.agendaItem {
                itemNameLabel.text = item.descriptionText
                dueDateLabel.text = getFormattedDate(item.dueDate as! Date)
            }
        }
    }
    
    private func getFormattedDate(_ dateToFormat: Date) -> String {
        let dateFormatter = AppGlobals.dateFormatter
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let currDateString = dateFormatter.string(from: dateToFormat)
        return currDateString
    }

}
