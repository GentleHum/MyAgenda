//
//  HomeCategoryTableViewCell.swift
//  MyAgenda
//
//  Created by Mike Vork on 3/21/17.
//  Copyright © 2017 Mike Vork. All rights reserved.
//

import UIKit

class HomeCategoryTableViewCell: UITableViewCell {

    @IBOutlet private weak var countLabel: UILabel!
    @IBOutlet private weak var icon: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    
    var item: CategoryListItem? {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        // load new information from our item (if any)
        if let item = self.item {
            countLabel.text = (item.taskCount > 0) ? String(item.taskCount) : " "
            icon.image = UIImage(named: item.iconName)
            nameLabel.text = item.name
        }
    }
    

}
