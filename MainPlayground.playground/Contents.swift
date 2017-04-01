//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport
import Foundation

PlaygroundPage.current.needsIndefiniteExecution = true

let dateToFormat = Date()
let dateFormatter = DateFormatter()
dateFormatter.dateFormat = "M/d/y"
let currDateString = dateFormatter.string(from: dateToFormat)
print(currDateString)