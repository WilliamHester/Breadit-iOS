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
        let string = NSMutableAttributedString(string: comment.submissionTitle!, attributes: [
                NSFontAttributeName: UIFont.italicSystemFontOfSize(13)
        ])
        string.appendAttributedString(NSAttributedString(string: " by "))
        string.appendAttributedString(NSAttributedString(string: "/u/\(comment.submissionAuthor!)", attributes: [
                NSForegroundColorAttributeName: Colors.infoColor
        ]))
        string.appendAttributedString(NSAttributedString(string: " in "))
        string.appendAttributedString(NSAttributedString(string: "/r/\(comment.subredditDisplay!)", attributes: [
                NSForegroundColorAttributeName: Colors.infoColor
        ]))
        cell.submissionTitle.attributedText = string
    }

}
