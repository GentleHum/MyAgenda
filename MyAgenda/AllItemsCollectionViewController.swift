//
//  AllItemsCollectionViewController.swift
//  MyAgenda
//
//  Created by Michael Vork on 6/12/17.
//  Copyright © 2017 Mike Vork. All rights reserved.
//

import UIKit

class AllItemsCollectionViewController: AgendaItemCollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.cellIdentifier = Storyboard.cellIdentifier
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadSectionData()
        collectionView?.reloadData()
        self.navigationItem.title = "All Items"
    }
    
    
    private func loadSectionData() {
        // clear the section data
        agendaItems.removeAll()
        sectionNames = ModelController.sharedInstance.getCategoryNames()
        
        print("sectionNames count: \(sectionNames.count)")  // zap
        
        for categoryName in sectionNames {
            print("appending for category: \(categoryName)")  // zap
            agendaItems.append(ModelController.sharedInstance.loadAgendaItems(matching: categoryName))
        }
        
        print("agendaItems count: \(agendaItems.count)")  // zap
        
    }
    

}
