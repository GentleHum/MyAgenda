//
//  CategoryCollectionViewController.swift
//  MyAgenda
//
//  Created by Michael Vork on 6/13/17.
//  Copyright © 2017 Mike Vork. All rights reserved.
//

import UIKit

class CategoryCollectionViewController: AgendaItemCollectionViewController {
    
    var categoryName: String?
    
    var categoryNumber: Int? {
        didSet {
            categoryName = ModelController.sharedInstance.localizedCategoryName(categoryNumber ?? 0)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        blankCellsPerSection = 0
        loadSectionData()
        collectionView?.reloadData()
        if let categoryNumber = categoryNumber {
            self.navigationItem.title = ModelController.sharedInstance.localizedCategoryName(categoryNumber)
        }
    }
    
    
    private func loadSectionData() {
        // clear the section data
        agendaItems.removeAll()
        sectionNames.removeAll()
        
        sectionNames.append(categoryName ?? "")
        agendaItems.append(ModelController.sharedInstance.loadAgendaItems(matching: Int16(categoryNumber ?? 0)))
    }
    
    override func setAddItemDefaults(forController controller: AddAgendaItemViewController) {
        controller.defaultCategoryNumber = categoryNumber
    }


}
