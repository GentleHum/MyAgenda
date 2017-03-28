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
    
    private var agendaItems = [AgendaItem]()
    
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
        agendaItems = ModelController.sharedInstance.loadAgendaItems(matching: categoryName)
//        tableView.reloadData()
        updateUI()
    }
   
    
    private func updateUI() {
        if mainLabel != nil && categoryName != nil {
            mainLabel.text = "CategoryViewController: " + categoryName! + " \(agendaItems.count)"
            
            self.navigationItem.title = categoryName!
        }
    }

}
