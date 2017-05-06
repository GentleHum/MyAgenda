//
//  RoundedButton.swift
//  CustomControlTask
//
//  Created by Mike Vork on 3/13/17.
//  Copyright © 2017 Mike Vork. All rights reserved.
//

import UIKit
import QuartzCore


@IBDesignable class RoundedButton: UIButton {
    static let clearCGColor = UIColor.clear as! CGColor
    
    @IBInspectable var borderColor: UIColor {
        get {
            return UIColor(cgColor: layer.borderColor ?? RoundedButton.clearCGColor)
        }
        
        set {
            layer.borderColor = newValue.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var radius: CGFloat {
        get {
            return layer.cornerRadius
        }
        
        set {
            layer.cornerRadius = newValue
        }
    }
    
}

