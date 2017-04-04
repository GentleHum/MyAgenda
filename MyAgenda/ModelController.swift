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
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "MyAgenda")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    
    private init() { // must be private to ensure it's thread safe
    }
    
    
    private func buildAgendaItemQuery(from startDate: Date?, to endDate: Date?) -> NSFetchRequest<NSFetchRequestResult> {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: AgendaItemProperties.entityName)
        request.predicate = NSPredicate(format: "(dueDate >= %@) AND (dueDate <= %@)",
                                        argumentArray: [startDate!, endDate!] )
        
        return request
    }
    
    
    private func buildAgendaItemQuery(categoryName: String? = nil) -> NSFetchRequest<NSFetchRequestResult> {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: AgendaItemProperties.entityName)
        if let name = categoryName {
            request.predicate = NSPredicate(format: "category == %@", name)
        }
        
        return request
    }
    
    func getAgendaItemCount(from startDate: Date, to endDate: Date) -> Int {
        var count = 0
        let context = self.persistentContainer.viewContext
        let request = buildAgendaItemQuery(from: startDate, to: endDate)
        
        do {
            count = try context.count(for: request)
        } catch let error as NSError {
            print("Fetching Error: \(error.userInfo)")
        }
        
        return count
    }
    
    func getAgendaItemCount(matching categoryName: String? = nil) -> Int {
        var count = 0
        let context = self.persistentContainer.viewContext
        let request = buildAgendaItemQuery(categoryName: categoryName)
        request.includesPropertyValues = false
        
        do {
            count = try context.count(for: request)
        } catch let error as NSError {
            print("Fetching Error: \(error.userInfo)")
        }
        
        return count
    }
    
    
    func loadAgendaItems(matching categoryName: String? = nil) -> [AgendaItem] {
        let context = self.persistentContainer.viewContext
        let request = buildAgendaItemQuery(categoryName: categoryName)
        
        do {
            let results = try context.fetch(request)
            agendaItems = results as! [AgendaItem]
            return agendaItems
        } catch let error as NSError {
            print("Fetching Error: \(error.userInfo)")
        }
        
        return [AgendaItem]()
    }
    
    func loadAgendaItems(from startDate: Date, to endDate: Date) -> [AgendaItem] {
        let context = self.persistentContainer.viewContext
        let request = buildAgendaItemQuery(from: startDate, to: endDate)
        
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
        let context = self.persistentContainer.viewContext
        
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
            self.saveContext()
            NotificationCenter.default.post(name: Notification.Name(rawValue: Notifications.dataChanged), object: self)
            return item
        }
        
        return nil
    }
    
    
    func deleteAgendaItem(_ itemToDelete: AgendaItem) {
        let context = self.persistentContainer.viewContext
        context.delete(itemToDelete)
        self.saveContext()
        NotificationCenter.default.post(name: Notification.Name(rawValue: Notifications.dataChanged), object: self)
    }
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    
}

