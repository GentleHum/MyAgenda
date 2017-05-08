//
//  AppGlobals.swift
//  MyAgenda
//
//  Created by Mike Vork on 3/30/17.
//  Copyright © 2017 Mike Vork. All rights reserved.
//

import Foundation


// global variable structure for the application

struct AppGlobals {
    static let dateFormatter = DateFormatter()
    
    static let iconDictionary: Dictionary<String,String> = [
        "Personal" : "category-blue-icon.png",
        "Work" : "category-purple-icon.png",
        "School" : "category-black-icon.png",
        ]

}
