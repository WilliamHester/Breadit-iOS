//
//  Account.swift
//  Breadit
//
//  Created by William Hester on 5/4/16.
//  Copyright © 2016 William Hester. All rights reserved.
//

import Foundation
import RealmSwift

class Account: Object {
    dynamic var username: String = ""
    dynamic var accessToken: String = ""
    dynamic var refreshToken: String = ""
    let subreddits = List<Subreddit>()
    
    override static func primaryKey() -> String? {
        return "username"
    }
}
