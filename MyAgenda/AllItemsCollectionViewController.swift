//
//  AllItemsCollectionViewController.swift
//  MyAgenda
//
//  Created by Michael Vork on 6/12/17.
//  Copyright © 2017 Mike Vork. All rights reserved.
//

import UIKit

class AllItemsCollectionViewController: AgendaItemCollectionViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadSectionData()
        collectionView?.reloadData()
        self.navigationItem.title = NSLocalizedString("All Items", comment: "All Items")
    }
    
    
    private func loadSectionData() {
        // clear the section data
        agendaItems.removeAll()
        sectionNames = ModelController.sharedInstance.getCategoryNames()
        
        for categoryName in sectionNames {
            agendaItems.append(ModelController.sharedInstance.loadAgendaItems(matching: categoryName))
        }
    }
    
    override func updateRecord(at indexPath: IndexPath) {
        let itemToUpdate = agendaItems[indexPath.section][agendaItemNumber(from: indexPath)]
        itemToUpdate.category = sectionNames[indexPath.section]
        ModelController.sharedInstance.saveContext()
    }
    

}
