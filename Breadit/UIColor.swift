//
//  UIColor.swift
//  Breadit
//
//  Created by William Hester on 5/11/16.
//  Copyright © 2016 William Hester. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(rgb: Int) {
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}