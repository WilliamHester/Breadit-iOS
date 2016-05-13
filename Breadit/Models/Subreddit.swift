//
// Created by William Hester on 5/12/16.
// Copyright (c) 2016 William Hester. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

class Subreddit: Object {
    dynamic var displayName: String = ""
    dynamic var descriptionHtml: String = ""
    dynamic var iconImg: String = ""
    dynamic var url: String = ""
    dynamic var subredditType: String = ""
    dynamic var submissionType: String = ""

    dynamic var over18: Bool = false
    dynamic var isDefault: Bool = false

    convenience init(json: JSON, isDefault: Bool = false) {
        self.init()

        self.displayName = json["display_name"].string!
        self.descriptionHtml = json["description_html"].string!
        self.iconImg = json["icon_img"].string!
        self.url = json["url"].string!
        self.subredditType = json["subreddit_type"].string!
        self.submissionType = json["submission_type"].string!
        self.over18 = json["over18"].bool!
        self.isDefault = isDefault
    }

    override static func primaryKey() -> String? {
        return "displayName"
    }
}
