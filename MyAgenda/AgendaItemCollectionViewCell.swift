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
    
    
    var agendaItem: AgendaItem? {
        didSet {
            updateUI()
        }
    }
    
    internal func updateUI() {
        // load new information from our item (if any)
        
//        guard itemNameLabel != nil,
//            categoryLabel != nil,
//            categoryImage != nil else { return }
        
        guard itemNameLabel != nil else { return }
        
        if let item = self.agendaItem {
//            if let iconName = AppGlobals.iconDictionary[item.category ?? ""] {
//                categoryImage.image = UIImage(named: iconName)
//            }
            itemNameLabel.text = item.descriptionText
//            categoryLabel.text = item.category
        }
    }
    
}
