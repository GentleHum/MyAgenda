//
//  ModelController.swift
//  MyAgenda
//
//  Created by Mike Vork on 3/25/17.
//  Copyright © 2017 Mike Vork. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class ModelController {
    static let sharedInstance = ModelController()
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    struct AgendaItemProperties {
        static let entityName = "AgendaItem"
        static let descriptionField = "descriptionText"
        static let categoryField = "category"
        static let priorityField = "priority"
        static let dueDateField = "dueDate"
    }
    
    private var agendaItems = [AgendaItem]()
    
    private init() { // must be private to ensure it's thread safe
    }
    
    func loadAgendaItems() -> [AgendaItem] {
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: AgendaItemProperties.entityName)
        
        do {
            let results = try context.fetch(fetchRequest)
            agendaItems = results as! [AgendaItem]
            return agendaItems
        } catch let error as NSError {
            print("Fetching Error: \(error.userInfo)")
        }
        
        return [AgendaItem]()
        
    }
    
    func addAgendaItem(descriptionText: String, category: String,
                       priority: Int, dueDate: Date) -> AgendaItem? {
        let context = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: AgendaItemProperties.entityName,
                                                in: context)
        
        if let item = NSManagedObject(entity: entity!, insertInto: context) as? AgendaItem {
            item.setValue(descriptionText,
                              forKey: AgendaItemProperties.descriptionField)
            item.setValue(category,
                              forKey: AgendaItemProperties.categoryField)
            item.setValue(priority,
                              forKey: AgendaItemProperties.priorityField)
            item.setValue(dueDate,
                          forKey: AgendaItemProperties.dueDateField)
            appDelegate.saveContext()
            return item
        }
        
        return nil
    }
    
    
    func deleteAgendaItem(_ itemToDelete: AgendaItem) {
        let context = appDelegate.persistentContainer.viewContext
        context.delete(itemToDelete)
        appDelegate.saveContext()
    }
    
    
}

