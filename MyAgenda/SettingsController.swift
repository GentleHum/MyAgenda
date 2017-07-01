//
//  SettingsController.swift
//  MyAgenda
//
//  Created by Mike Vork on 6/30/17.
//  Copyright © 2017 Mike Vork. All rights reserved.
//

import Foundation

class SettingsController {
    static let sharedInstance = SettingsController()
    private let userDefaults = UserDefaults.standard
    
    private static let DEFAULT_CATEGORY = 0
    private static let DEFAULT_PRIORITY = 1

    private init() {}  // must be private to ensure it's thread-safe
    
    struct PropertyNames {
        static let defaultCategory = "DefaultCategory"
        static let defaultPriority = "DefaultPriority"
    }

    
    var defaultCategory: Int = DEFAULT_CATEGORY {
        didSet {
            userDefaults.set(defaultCategory, forKey: PropertyNames.defaultCategory)
        }
    }
    
    var defaultPriority: Int = DEFAULT_PRIORITY {
        didSet {
            userDefaults.set(defaultPriority, forKey: PropertyNames.defaultPriority)
        }
    }
    
    
    func load() {
        defaultCategory = userDefaults.object(forKey: PropertyNames.defaultCategory) as? Int ?? SettingsController.DEFAULT_CATEGORY
        
        defaultPriority = userDefaults.object(forKey: PropertyNames.defaultPriority) as? Int ?? SettingsController.DEFAULT_PRIORITY
        if defaultPriority <= 0 {  // make sure it's 1-based rather than 0-based
            defaultPriority = SettingsController.DEFAULT_PRIORITY
        }
    }
    
    
    func save() {
        userDefaults.synchronize()
    }
    
}
