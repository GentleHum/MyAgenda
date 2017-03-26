//
//  AgendaItemTVC.swift
//  MyAgenda
//
//  Created by Mike Vork on 3/25/17.
//  Copyright © 2017 Mike Vork. All rights reserved.
//

import UIKit
import CoreData


class AgendaItemTVC: UITableViewCell {

    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var categoryImage: UIImageView!
    
    var agendaItem: AgendaItem? {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        // load new information from our item (if any)
        if let item = self.agendaItem {
            let iconName = item.category == "Personal" ? "category-blue-icon.png" : "category-purple-icon.png"
            itemNameLabel.text = item.descriptionText
            categoryLabel.text = item.category
            categoryImage.image = UIImage(named: iconName)
        }
    }

}
