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
//        if let newItem = addAgendaItem(descriptionText: "OTF Workout", category: "Personal", priority: 2, dueDate: Date()) {
//            agendaItems.append(newItem)
//        }
//        if let newItem = addAgendaItem(descriptionText: "Work on final project", category: "Career Foundry", priority: 2, dueDate: Date()) {
//            agendaItems.append(newItem)
//        }
//        if let newItem = addAgendaItem(descriptionText: "Cancel Wild tickets", category: "Personal", priority: 1, dueDate: Date()) {
//            agendaItems.append(newItem)
//        }
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
            appDelegate.saveContext()
            return item
        }
        
        return nil
    }
    
    
    func deleteAgendaItem() {
        
    }
    
    
}


//class func loadCategories() -> [TaskCategory] {
//    let appDelegate = UIApplication.shared.delegate as! AppDelegate
//    let managedContext = appDelegate.persistentContainer.viewContext
//    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskCategory")
//    
//    do {
//        let results = try managedContext.fetch(fetchRequest)
//        let categories = results as! [TaskCategory]
//        return categories
//    } catch let error as NSError {
//        print("Fetching Error: \(error.userInfo)")
//    }
//    
//    return [TaskCategory]()
//    
//}
//
//class func addCategory(name: String, iconName: String, taskCount: Int) -> TaskCategory? {
//    let appDelegate = UIApplication.shared.delegate as! AppDelegate
//    let context = appDelegate.persistentContainer.viewContext
//    let entity = NSEntityDescription.entity(forEntityName: "TaskCategory", in: context)
//    
//    if let category = NSManagedObject(entity: entity!, insertInto: context) as? TaskCategory {
//        category.setValue(name, forKey: "name")
//        category.setValue(iconName, forKey: "iconName")
//        category.setValue(taskCount, forKey: "taskCount")
//        appDelegate.saveContext()
//        return category
//    }
//    
//    return nil
//}
