//
// Created by William Hester on 4/23/16.
// Copyright (c) 2016 William Hester. All rights reserved.
//

import Foundation

class SubmissionStore: ListingStore {

    var content = [Votable]()
    var failedLoad = false
    let urlPart: String
    let display: String
    var searchQuery: String? = nil

    init(searchQuery: String) {
        display = searchQuery
        urlPart = "search"
        self.searchQuery = searchQuery
    }
    
    init(subredditDisplay: String) {
        display = subredditDisplay == "" ? "Front Page" : subredditDisplay
        urlPart = subredditDisplay.length == 0 ? "" : "r/" + subredditDisplay
        self.searchQuery = ""
    }

    func loadContent(onLoad: (Int, Int) -> ()) {
        let after: String?
        if let last = content.last {
            after = last.name
        } else {
            after = nil
        }
        RedditAPI.getSubmissions(urlPart, query: searchQuery, after: after) { submissions in
            let oldCount = self.content.count
            for sub in submissions {
                self.content.append(sub)
            }
            if submissions.count == 0 {
                self.failedLoad = true
            }
            onLoad(oldCount, self.content.count)
        }
    }
    
    func refreshContent(onLoad: (Bool) -> ()) {
        RedditAPI.getSubmissions(urlPart, query: searchQuery, after: nil) { submissions in
            var same = true
            for (i, submission) in submissions.enumerate() {
                if i >= self.content.count {
                    same = false
                    break
                }
                if submission.name != self.content[i].name {
                    same = false
                    break
                }
            }
            if !same {
                self.content = [Votable]()
                for sub in submissions {
                    self.content.append(sub)
                }
            }
            onLoad(!same)
        }
    }
}
