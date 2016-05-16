//
//  SubredditStore.swift
//  Breadit
//
//  Created by William Hester on 5/12/16.
//  Copyright © 2016 William Hester. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class SubredditStore {

    static var realm: Realm!
    var loginManager: LoginManager!

    var subreddits = [Subreddit]() {
        didSet {
            subreddits.sortInPlace { sub1, sub2 in
                return sub1.displayName.lowercaseString < sub2.displayName.lowercaseString
            }
        }
    }

    func loadSubreddits(onLoad: () -> ()) {
        if let account = loginManager.account {
            subreddits = Array(account.subreddits)
            if subreddits.count == 0 {
                RedditAPI.getMySubreddits { newSubs in
                    try! SubredditStore.realm.write {
                        account.subreddits.appendContentsOf(newSubs)
                    }
                    self.subreddits = newSubs
                    onLoad()
                }
            }
        } else {
        	subreddits = Array(SubredditStore.realm.objects(Subreddit).filter("isDefault = true"))
        	if subreddits.count == 0 {
            	RedditAPI.getDefaultSubreddits { newSubs in
                	self.subreddits = newSubs
                	onLoad()
            	}
        	}
        }
    }
    
}
