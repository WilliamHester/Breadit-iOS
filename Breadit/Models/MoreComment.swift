//
// Created by William Hester on 4/28/16.
// Copyright (c) 2016 William Hester. All rights reserved.
//

import Foundation
import SwiftyJSON

class MoreComment: Comment {
    
    var level: Int = 0

    let children: [String]

    init(json: JSON, level: Int) {
        self.level = level
        if let names = json["children"].arrayObject as? [String] {
            self.children = names
        } else {
            self.children = []
        }
    }

}
