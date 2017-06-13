//
//  AgendaItemCollectionViewCell.swift
//  MyAgenda
//
//  Created by Michael Vork on 5/24/17.
//  Copyright © 2017 Mike Vork. All rights reserved.
//

import UIKit

class AgendaItemCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var dueDateLabel: UILabel!
    
    
    var agendaItem: AgendaItem? {
        didSet {
            updateUI()
        }
    }
    
    internal func updateUI() {
        
        if let item = self.agendaItem {
            if itemNameLabel != nil {
                itemNameLabel.text = item.descriptionText
            }
            
            if categoryLabel != nil {
                categoryLabel.text = item.category
            }
            
            if dueDateLabel != nil {
                if let dueDate = item.dueDate {
                    dueDateLabel.text = AppGlobals.dateFormatter.getString(from: dueDate as Date,
                                  with: "M/d/y")
                }
            }
            
            if categoryImage != nil {
                if let iconName = AppGlobals.iconDictionary[item.category ?? ""] {
                    categoryImage.image = UIImage(named: iconName)
                }
            }
        }
    }
    
}
