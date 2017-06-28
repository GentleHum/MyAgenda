//
//  AnalyticsController.swift
//  MyAgenda
//
//  Created by Michael Vork on 6/28/17.
//  Copyright © 2017 Mike Vork. All rights reserved.
//

import Foundation
import Flurry_iOS_SDK

class AnalyticsController {
    static let sharedInstance = AnalyticsController()
    static let flurryApplicationKey = "WYFF5KR6TH6BZ64TRSKK"
    

    private init() { // must be private to ensure it's thread safe
    }
    
    func startSession() {
        Flurry.startSession(AnalyticsController.flurryApplicationKey, with: FlurrySessionBuilder
            .init()
            .withCrashReporting(true)
            .withLogLevel(FlurryLogLevelAll))
    }

    func addedAgendaItem() {
        Flurry.logEvent("AddedAgendaItem")
    }

    func completedAgendaItem() {
        Flurry.logEvent("CompletedAgendaItem")
    }

    func deletedAgendaItem() {
        Flurry.logEvent("DeletedAgendaItem")
    }

    func editedAgendaItem() {
        Flurry.logEvent("EditedAgendaItem")
    }

}
