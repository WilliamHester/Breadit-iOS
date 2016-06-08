//
// Created by William Hester on 6/8/16.
// Copyright (c) 2016 William Hester. All rights reserved.
//

import Foundation

class UserStore: ListingStore {

    var content = [Votable]()
    var failedLoad = false
    let display: String

    init(username: String) {
        self.display = username
    }

    func loadContent(onLoad: (Int, Int) -> ()) {
        let after: String?
        if let last = content.last {
            after = last.name
        } else {
            after = nil
        }
        RedditAPI.getUser(display, after: after) { votables in
            let oldCount = self.content.count
            self.content += votables
            if votables.count == 0 {
                self.failedLoad = true
            }
            onLoad(oldCount, self.content.count)
        }
    }

    func refreshContent(onLoad: (Bool) -> ()) {
        RedditAPI.getUser(display, after: nil) { votables in
            var same = true
            for (i, votable) in votables.enumerate() {
                if i >= self.content.count {
                    same = false
                    break
                }
                if votable.name != self.content[i].name {
                    same = false
                    break
                }
            }
            if !same {
                self.content = votables
            }
            onLoad(!same)
        }
    }
}
