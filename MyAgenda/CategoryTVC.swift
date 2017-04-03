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
        
        guard itemNameLabel != nil,
            dueDateLabel != nil else { return }
        
        // load new information from our item (if any)
        if let item = self.agendaItem {
            itemNameLabel.text = item.descriptionText
            if let dueDate = item.dueDate {
                dueDateLabel.text =
                    AppGlobals.dateFormatter.getString(from: dueDate as Date,
                                                       with: "M/d/y")
            }
        }
    }

}
