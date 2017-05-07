//
//  AgendaItem-Extensions.swift
//  MyAgenda
//
//  Created by Mike Vork on 4/21/17.
//  Copyright © 2017 Mike Vork. All rights reserved.
//

import Foundation

// extensions for the AgendaItem Core Data model object

extension AgendaItem {
    struct Properties {
        static let entityName = "AgendaItem"
        static let descriptionField = "descriptionText"
        static let categoryField = "category"
        static let priorityField = "priority"
        static let dueDateField = "dueDate"
    }

    func set(descriptionText: String, category: String,
             priority: Int, dueDate: Date) {
        self.setValue(descriptionText, forKey: Properties.descriptionField)
        self.setValue(category, forKey: Properties.categoryField)
        self.setValue(priority, forKey: Properties.priorityField)
        self.setValue(dueDate, forKey: Properties.dueDateField)
        
    }
    
}
