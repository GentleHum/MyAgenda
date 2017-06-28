//
//  AgendaItemCollectionViewCell.swift
//  MyAgenda
//
//  Created by Michael Vork on 5/24/17.
//  Copyright © 2017 Mike Vork. All rights reserved.
//

import UIKit


protocol AgendaItemMenuDelegate {
    func didPressComplete()
    func didPressDelete()
    func didPressEdit()
}

class AgendaItemCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var menuView: UIView!
    
    var menuDelegate: AgendaItemMenuDelegate?
    
    var agendaItem: AgendaItem? {
        didSet {
            updateUI()
        }
    }
    
    var menuIsHidden: Bool = true {
        didSet {
            menuView?.isHidden = menuIsHidden
        }
    }
    
    internal func updateUI() {
        
        if let item = self.agendaItem {
            if itemNameLabel != nil {
                itemNameLabel.text = item.descriptionText
            }
            
            if categoryLabel != nil {
                categoryLabel.text = ModelController.sharedInstance.localizedCategoryName(Int(item.category))
            }
            
            if dueDateLabel != nil {
                if let dueDate = item.dueDate {
                    dueDateLabel.text = AppGlobals.dateFormatter.getString(from: dueDate as Date,
                                  with: "M/d/y")
                }
            }
            
            if categoryImage != nil {
                let iconName = AppGlobals.iconArray[Int(item.category)]
                categoryImage.image = UIImage(named: iconName)
            }
        }
        
    }
    
    // MARK: input actions
    
    @IBAction func didPressComplete(_ sender: UIButton) {
        menuDelegate?.didPressComplete()
    }
    
    @IBAction func didPressDelete(_ sender: UIButton) {
        menuDelegate?.didPressDelete()
    }
    
    @IBAction func didPressEdit(_ sender: UIButton) {
        menuDelegate?.didPressEdit()
    }
    
    
}
