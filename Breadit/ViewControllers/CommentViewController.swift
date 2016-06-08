//
//  DetailViewController.swift
//  Breadit
//
//  Created by William Hester on 4/22/16.
//  Copyright © 2016 William Hester. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SafariServices

class CommentViewController: ContentViewController, ReplyDelegate {

    var submission: Submission!
    var permalink: String? {
        didSet {
            self.configureView(permalink!)
        }
    }
    var comments = [Comment]()
    let loginManager = LoginManager.singleton
    var loadedMoreComments = Set<String>()

    func configureView(permalink: String) {
        RedditAPI.getComments(permalink) { submission, comments in
            guard submission != nil else {
                return
            }
            var modifiedIndexPaths = [NSIndexPath]()
            UIView.setAnimationsEnabled(false)
            self.tableView.beginUpdates()
            if self.submission == nil {
            	self.submission = submission
                modifiedIndexPaths.append(NSIndexPath(forRow: 0, inSection: 0))
            }
            self.comments = comments
            for i in 0..<comments.count {
                modifiedIndexPaths.append(NSIndexPath(forRow: i, inSection: 1))
            }
            self.tableView.insertRowsAtIndexPaths(modifiedIndexPaths, withRowAnimation: .None)
            self.tableView.endUpdates()
            UIView.setAnimationsEnabled(true)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        definesPresentationContext = true
        
        view.backgroundColor = Colors.backgroundColor

        title = "Comments"

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        tableView.separatorStyle = .None

        tableView.registerClass(SubmissionSelfPostCellView.self, forCellReuseIdentifier: "SubmissionSelfPostCellView")
    }

    override func showActionsForRowAtIndexPath(indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            showSubmissionOptions(submission)
            return
        }
        if let comment = comments[indexPath.row] as? TextComment {
            showCommentOptions(comment)
        }
    }
    
    private func showSubmissionOptions(submission: Submission) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        alertController.addAction(UIAlertAction(title: "Reply", style: .Default) { _ in
            let reply = ReplyViewController()
            reply.modalPresentationStyle = .OverCurrentContext
            reply.modalTransitionStyle = .CoverVertical
            reply.delegate = self
            reply.setSubmission(submission)
            self.presentViewController(self.wrapInNavigationController(reply), animated: true, completion: nil)
            })
        alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    private func showCommentOptions(comment: TextComment) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        alertController.addAction(UIAlertAction(title: "Reply", style: .Default) { _ in
            let reply = ReplyViewController()
            reply.modalPresentationStyle = .OverCurrentContext
            reply.modalTransitionStyle = .CoverVertical
            reply.delegate = self
            reply.setComment(comment)
            self.presentViewController(self.wrapInNavigationController(reply), animated: true, completion: nil)
        })
        alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        presentViewController(alertController, animated: true, completion: nil)
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return submission != nil ? 1 : 0
        }
        return comments.count
    }

    override func tableView(tableView: UITableView,
                            cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            return setUpRowForSubmission(submission, atIndexPath: indexPath)
        }
        return setUpRowForComment(comments[indexPath.row], atIndexPath: indexPath)
    }

    override func tableView(tableView: UITableView,
    		didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard indexPath.section == 1 else {
            tableView.deselectRowAtIndexPath(indexPath, animated: false)
            return
        }
        let comment = comments[indexPath.row]
        if let textComment = comment as? TextComment {
            if textComment.hidden {
                expandComment(textComment, index: indexPath.row)
            } else {
                collapseComment(textComment, index: indexPath.row)
            }
        } else {
            loadMoreComments(comment as! MoreComment, index: indexPath.row)
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }

    // MARK: - Reddit operations

    private func loadMoreComments(comment: MoreComment, index: Int) {
        guard !loadedMoreComments.contains(comment.name) else {
            return
        }
        loadedMoreComments.insert(comment.name)
        RedditAPI.getMoreComments(comment, forSubmission: submission) { comments in
            var indexPaths = [NSIndexPath]()
            for i in index..<index + comments.count {
                indexPaths.append(NSIndexPath(forRow: i, inSection: 1))
            }
            self.comments.removeAtIndex(index)
            self.comments.insertContentsOf(comments, at: index)
            self.tableView.beginUpdates()
            self.tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: index, inSection: 1)], withRowAnimation: .Fade)
            self.tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Fade)
            self.tableView.endUpdates()
        }
    }

    private func collapseComment(comment: TextComment, index: Int) {
        comment.hidden = true
        var hiddenComments = [Comment]()
        var indexPaths = [NSIndexPath]()
        var end = index + 1
        for i in index + 1..<comments.count {
            if comments[i].level > comment.level {
                hiddenComments.append(comments[i])
                indexPaths.append(NSIndexPath(forItem: i, inSection: 1))
            } else {
                end = i
                break
            }
        }
        if index + 1 < end {
        	comments.removeRange(index + 1..<end)
        }
        comment.replies = hiddenComments

        tableView.beginUpdates()
        tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Fade)
        tableView.reloadRowsAtIndexPaths([NSIndexPath(forItem: index, inSection: 1)],
    			withRowAnimation: .Fade)
        tableView.endUpdates()
        
        if comments.count < index + 1 {
        	tableView.scrollToRowAtIndexPath(NSIndexPath(forItem: index + 1, inSection: 1),
            		atScrollPosition: .Top, animated: true)
        }
    }

    private func expandComment(comment: TextComment, index: Int) {
        comment.hidden = false

        var indexPaths = [NSIndexPath]()
        if comment.replies!.count > 0 {
            for i in 1...comment.replies!.count {
                indexPaths.append(NSIndexPath(forRow: i + index, inSection: 1))
            }
            comments.insertContentsOf(comment.replies!, at: index + 1)
        }
        comment.replies = nil

        tableView.beginUpdates()
        tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Fade)
        tableView.reloadRowsAtIndexPaths([NSIndexPath(forItem: index, inSection: 1)],
                withRowAnimation: .Fade)
        tableView.endUpdates()
    }

    // MARK: BodyLabelDelegate
    func bodyLabel(link: Link) {
        showViewControllerFor(link)
    }

    // MARK: - View Controller Previewing Delegate
    
    override func previewingContext(previewingContext: UIViewControllerPreviewing,
                           viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let bodyLabel = previewingContext.sourceView as? BodyLabel else {
            return nil
        }
        if let (_, link) = bodyLabel.elementAtLocation(location) {
            return viewControllerFor(link)
        }
        return nil
    }
    
    // MARK: - ReplyDelegate
    
    func didReplyTo(name: String, withTextComment textComment: TextComment) {
        if submission.name == name {
            comments.insert(textComment, atIndex: 0)
            tableView.beginUpdates()
            tableView.insertRowsAtIndexPaths([NSIndexPath(forItem: 0, inSection: 1)],
            		withRowAnimation: .Automatic)
            tableView.endUpdates()
            return
        }
        var pos: Int? = nil
        for (num, comment) in comments.enumerate() {
            if let textComment = comment as? TextComment {
                if textComment.name == name {
                    pos = num
                    break
                }
            }
        }
        if let position = pos {
            comments.insert(textComment, atIndex: position + 1)
            tableView.beginUpdates()
            tableView.insertRowsAtIndexPaths([NSIndexPath(forItem: position + 1, inSection: 1)],
                    withRowAnimation: .Automatic)
            tableView.endUpdates()
        }
    }

    // MARK: - ContentViewController

    override func reusableRowForSubmission(submission: Submission, atIndexPath indexPath: NSIndexPath) -> SubmissionCellView {
        if submission.selftextHtml != nil {
            let cell = tableView.dequeueReusableCellWithIdentifier("SubmissionSelfPostCellView")
                    as! SubmissionSelfPostCellView
            cell.contentBody.attributedText = HTMLParser(escapedHtml: submission.selftextHtml!,
                    font: UIFont.systemFontOfSize(13.0)).attributedString
            cell.contentBody.delegate = self
            return cell
        }
        return super.reusableRowForSubmission(submission, atIndexPath: indexPath)
    }
}
