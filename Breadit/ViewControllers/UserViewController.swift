//
// Created by William Hester on 6/10/16.
// Copyright (c) 2016 William Hester. All rights reserved.
//

import UIKit

class UserViewController: ListingViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.registerClass(SubmissionCommentCellView.self, forCellReuseIdentifier: "SubmissionCommentCellView")
    }

    override func setUpRowForComment(comment: Comment, atIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        if let textComment = comment as? TextComment {
            let textCommentCell = tableView.dequeueReusableCellWithIdentifier("SubmissionCommentCellView")
                    as! SubmissionCommentCellView
            setUpSubmissionCommentView(textCommentCell, forComment: textComment)
            setUpTextCommentView(textCommentCell, forComment: textComment)
            cell = textCommentCell
        } else {
            let moreComments = tableView.dequeueReusableCellWithIdentifier("MoreCommentCellView")
                    as! MoreCommentCellView
            setUpMoreCommentView(moreComments, forComment: comment)
            cell = moreComments
        }
        return cell
    }

    func setUpSubmissionCommentView(cell: SubmissionCommentCellView, forComment comment: TextComment) {
        cell.submissionAuthor.text = "/u/\(comment.submissionAuthor!)"
        cell.submissionTitle.text = comment.submissionTitle!
        cell.submissionSubreddit.text = "/r/\(comment.subredditDisplay!)"
    }

}
