//
//  Colors.swift
//  Breadit
//
//  Created by William Hester on 5/11/16.
//  Copyright © 2016 William Hester. All rights reserved.
//

import UIKit

let imageColor = UIColor(rgb: 0x85bf25)
let selectedImageColor = UIColor(rgb: 0xd4efa9)
let youTubeColor = UIColor(rgb: 0xb31217)
let selectedYouTubeColor = UIColor(rgb: 0xf6a2a5)
let redditColor = UIColor(rgb: 0xff8b24)
let selectedRedditColor = UIColor(rgb: 0xffc999)
let urlColor = UIColor(rgb: 0x0066ff)
let selectedUrlColor = UIColor(rgb: 0xccccff)

class Colors {
    static var theme = Theme(backgroundColor: UIColor(rgb: 0x202020),
                             secondaryColor: UIColor(rgb: 0x2e2e2e),
                             textColor: UIColor.whiteColor(),
                             secondaryTextColor: UIColor(rgb: 0xa0a0a0),
                             titleBarColor: UIColor.blackColor(),
                             infoColor: UIColor(rgb: 0x6A98AF))

    static var backgroundColor: UIColor {
        return theme.backgroundColor
    }
    
    static var secondaryColor: UIColor {
        return theme.secondaryColor
    }

    static var textColor: UIColor {
        return theme.textColor
    }
    
    static var secondaryTextColor: UIColor {
        return theme.secondaryTextColor
    }

    static var titleBarColor: UIColor {
        return theme.titleBarColor
    }
    
    static var infoColor: UIColor {
        return theme.infoColor
    }
}
