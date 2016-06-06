//
// Created by William Hester on 4/23/16.
// Copyright (c) 2016 William Hester. All rights reserved.
//

import Foundation

class SubmissionStore {

    var submissions = [Submission]()
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
        display = subredditDisplay
        urlPart = subredditDisplay.length == 0 ? "" : "r/" + subredditDisplay
        self.searchQuery = ""
    }

    func loadSubmissions(onLoad: (Int, Int) -> ()) {
        let after: String?
        if let last = submissions.last {
            after = last.name
        } else {
            after = nil
        }
        RedditAPI.getSubmissions(urlPart, query: searchQuery, after: after) { submissions in
            let oldCount = self.submissions.count
            self.submissions += submissions
            if submissions.count == 0 {
                self.failedLoad = true
            }
            onLoad(oldCount, self.submissions.count)
        }
    }
    
    func refreshSubmissions(onLoad: (Bool) -> ()) {
        RedditAPI.getSubmissions(urlPart, query: searchQuery, after: nil) { submissions in
            var same = true
            for (i, submission) in submissions.enumerate() {
                if i >= self.submissions.count {
                    same = false
                    break
                }
                if submission.name != self.submissions[i].name {
                    same = false
                    break
                }
            }
            if !same {
                self.submissions = submissions
            }
            onLoad(!same)
        }
    }
}
