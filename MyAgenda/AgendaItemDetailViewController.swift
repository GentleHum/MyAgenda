//
//  AgendaItemDetailViewController.swift
//  MyAgenda
//
//  Created by Mike Vork on 3/26/17.
//  Copyright © 2017 Mike Vork. All rights reserved.
//

import UIKit

class AgendaItemDetailViewController: UIViewController {

    var agendaItem: AgendaItem? {
        didSet {
            updateUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    private func updateUI() {
        
    }

}
