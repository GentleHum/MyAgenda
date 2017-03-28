//
//  AgendaItemTVC.swift
//  MyAgenda
//
//  Created by Mike Vork on 3/25/17.
//  Copyright © 2017 Mike Vork. All rights reserved.
//

import UIKit

class AgendaItemTVC: UITableViewCell {

    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var categoryImage: UIImageView!
    
    private var iconDictionary: Dictionary<String,String> = [
        "Personal" : "category-blue-icon.png",
        "Work" : "category-purple-icon.png",
        "School" : "category-black-icon.png",
    ]
    
    var agendaItem: AgendaItem? {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        // load new information from our item (if any)
        if itemNameLabel != nil {  // verify outlets are configured
            if let item = self.agendaItem {
                if let iconName = iconDictionary[item.category ?? ""] {
                    categoryImage.image = UIImage(named: iconName)
                }
                itemNameLabel.text = item.descriptionText
                categoryLabel.text = item.category
            }
        }
    }

}