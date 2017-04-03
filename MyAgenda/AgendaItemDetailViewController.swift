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
        
        guard descriptionTextLabel != nil,
            categoryLabel != nil,
            priorityLabel != nil,
            dueDateLabel != nil else { return }
        
        // load new information from our item (if any)
        if let item = self.agendaItem {
            descriptionTextLabel.text = item.descriptionText
            categoryLabel.text = item.category
            priorityLabel.text = "Priority \(item.priority)"
            if item.dueDate != nil {
                let formattedDate =
                    AppGlobals.dateFormatter.getString(from: item.dueDate! as Date, with: "M/d/y")
                dueDateLabel.text = "Due on \(formattedDate)"
            } else {
                dueDateLabel.text = "Unspecified due date"
            }
        }
        
    }
    
}
