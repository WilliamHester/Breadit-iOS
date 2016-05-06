//
// Created by William Hester on 4/23/16.
// Copyright (c) 2016 William Hester. All rights reserved.
//

import Foundation

class SubmissionStore {

    var submissions = [Submission]()
    var failedLoad = false

    func loadSubmissions(onLoad: (Int, Int) -> ()) {
        let after: String
        if let first = submissions.last {
            after = first.name
        } else {
            after = ""
        }
        RedditAPI.getSubmissions(after) { submissions in
            let oldCount = self.submissions.count
            self.submissions += submissions
            if submissions.count == 0 {
                self.failedLoad = true
            }
            onLoad(oldCount, self.submissions.count)
        }
    }
    
    func refreshSubmissions(onLoad: (Bool) -> ()) {
        RedditAPI.getSubmissions("") { submissions in
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
            onLoad(!same)
        }
    }
}
