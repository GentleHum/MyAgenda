//
//  UISegmentedControl-Extensions.swift
//  MyAgenda
//
//  Created by Michael Vork on 6/19/17.
//  Copyright © 2017 Mike Vork. All rights reserved.
//

import UIKit

extension UISegmentedControl {
    func setSelectedIndex(toItemWithTitle title: String?) {
        self.selectedSegmentIndex = 0
        if let selectedTitle = title {
            for segmentNumber in 0..<self.numberOfSegments {
                if self.titleForSegment(at: segmentNumber) == selectedTitle {
                    self.selectedSegmentIndex = segmentNumber
                    return
                }
            }
        }
    }
    
}
