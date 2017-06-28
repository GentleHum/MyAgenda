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
        
        for categoryNumber in 0..<sectionNames.count {
//            let localizedCategoryName = NSLocalizedString(categoryName, comment: "category")
            agendaItems.append(ModelController.sharedInstance.loadAgendaItems(matching: Int16(categoryNumber)))
        }
    }
    
    override func updateRecord(at indexPath: IndexPath) {
        let itemToUpdate = agendaItems[indexPath.section][agendaItemNumber(from: indexPath)]
        itemToUpdate.category = Int16(indexPath.section)
        ModelController.sharedInstance.saveContext()
    }
    

}
