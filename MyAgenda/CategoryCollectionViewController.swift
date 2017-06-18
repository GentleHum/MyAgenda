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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        blankCellsPerSection = 0
        loadSectionData()
        collectionView?.reloadData()
        self.navigationItem.title = categoryName
    }
    
    
    private func loadSectionData() {
        // clear the section data
        agendaItems.removeAll()
        sectionNames.removeAll()
        
        sectionNames.append(categoryName ?? "")
        agendaItems.append(ModelController.sharedInstance.loadAgendaItems(matching: categoryName))        
    }

}
