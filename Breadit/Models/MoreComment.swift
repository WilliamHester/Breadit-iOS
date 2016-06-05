//
// Created by William Hester on 4/28/16.
// Copyright (c) 2016 William Hester. All rights reserved.
//

import Foundation
import SwiftyJSON

class MoreComment: Comment {

    let children: [String]

    override init(json: JSON, level: Int) {
        if let names = json["children"].arrayObject as? [String] {
            self.children = names
        } else {
            self.children = []
        }
        super.init(json: json, level: level)
    }

}
