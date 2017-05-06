//
//  HomeTableViewCell.swift
//  MyAgenda
//
//  Created by Mike Vork on 3/20/17.
//  Copyright © 2017 Mike Vork. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    
    var item: HomeListItem? {
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
