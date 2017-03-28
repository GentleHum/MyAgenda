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
    
    struct Notifications {
        static let dataChanged = "com.gentlehum.MyAgenda.dataChanged"
    }
    
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
    
    private func buildGetAgendaItemQuery(categoryName: String? = nil) -> NSFetchRequest<NSFetchRequestResult> {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: AgendaItemProperties.entityName)
        if let name = categoryName {
            request.predicate = NSPredicate(format: "category == %@", name)
        }
     
        return request
    }
    
    func getAgendaItemCount(matching categoryName: String? = nil) -> Int {
        var count = 0
        let context = appDelegate.persistentContainer.viewContext
        let request = buildGetAgendaItemQuery(categoryName: categoryName)
        
        do {
            count = try context.count(for: request)
        } catch let error as NSError {
           print("Fetching Error: \(error.userInfo)")
        }
        
        return count
    }
    
    
    func loadAgendaItems(matching categoryName: String? = nil) -> [AgendaItem] {
        let context = appDelegate.persistentContainer.viewContext
        let request = buildGetAgendaItemQuery(categoryName: categoryName)

        do {
            let results = try context.fetch(request)
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
            NotificationCenter.default.post(name: Notification.Name(rawValue: Notifications.dataChanged), object: self)
            return item
        }
        
        return nil
    }
    
    
    func deleteAgendaItem(_ itemToDelete: AgendaItem) {
        let context = appDelegate.persistentContainer.viewContext
        context.delete(itemToDelete)
        appDelegate.saveContext()
        NotificationCenter.default.post(name: Notification.Name(rawValue: Notifications.dataChanged), object: self)
    }
    
    
}

