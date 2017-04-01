//
//  DateFormatter-Extensions.swift
//  MyAgenda
//
//  Created by Mike Vork on 4/1/17.
//  Copyright © 2017 Mike Vork. All rights reserved.
//

import Foundation

extension DateFormatter {
    func getString(from date: Date, with format: String) -> String {
        self.dateFormat = format
        return self.string(from: date)
    }
}
