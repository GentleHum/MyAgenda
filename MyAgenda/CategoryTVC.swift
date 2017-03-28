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
// zap                dueDateLabel.text = String(describing: item.dueDate)
                dueDateLabel.text = "Today"
            }
        }
    }

}
