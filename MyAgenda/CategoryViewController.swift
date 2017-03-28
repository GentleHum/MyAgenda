//
//  CategoryViewController.swift
//  MyAgenda
//
//  Created by Mike Vork on 3/28/17.
//  Copyright © 2017 Mike Vork. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController {

    @IBOutlet weak var mainLabel: UILabel!
    
    var categoryName: String? {
        didSet {
            updateUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        updateUI()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateUI()
    }
    
    private func updateUI() {
        if mainLabel != nil && categoryName != nil {
            mainLabel.text = "CategoryViewController: " + categoryName!
            
            self.navigationItem.title = categoryName!
        }
    }

}
