//
//  AgendaItemDetailViewController.swift
//  MyAgenda
//
//  Created by Mike Vork on 3/26/17.
//  Copyright © 2017 Mike Vork. All rights reserved.
//

import UIKit

class AgendaItemDetailViewController: UIViewController {

    @IBOutlet weak var descriptionTextLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var priorityLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    
    
    var agendaItem: AgendaItem? {
        didSet {
            updateUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
    }


    private func updateUI() {
        // load new information from our item (if any)
        if let item = self.agendaItem {
            if descriptionTextLabel != nil {
                descriptionTextLabel.text = item.descriptionText
                categoryLabel.text = item.category
                priorityLabel.text = "Priority \(item.priority)"
                if item.dueDate != nil {
                    dueDateLabel.text = "Due on \(getFormattedDate(item.dueDate! as Date))"
                } else {
                    dueDateLabel.text = "Unspecified due date"
                }
            }
        }
        
    }
    
    private func getFormattedDate(_ dateToFormat: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let currDateString = dateFormatter.string(from: dateToFormat)
        return currDateString
    }

}
