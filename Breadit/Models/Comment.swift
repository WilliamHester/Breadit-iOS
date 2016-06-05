//
// Created by William Hester on 4/28/16.
// Copyright (c) 2016 William Hester. All rights reserved.
//

import Foundation
import SwiftyJSON

class Comment {
    let level: Int
    let parentId: String

    init(json: JSON, level: Int) {
        self.level = level
        self.parentId = json["parent_id"].string!
    }
}
