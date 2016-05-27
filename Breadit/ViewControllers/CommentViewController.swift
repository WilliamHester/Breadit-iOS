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

class CommentViewController: UITableViewController, BodyLabelDelegate,
		UIViewControllerPreviewingDelegate, SubmissionCellDelegate {

    var submission: Submission?
    var permalink: String? {
        didSet {
            self.configureView(permalink!)
        }
    }
    var comments = [Comment]()
    let loginManager = LoginManager.singleton

    func configureView(permalink: String) {
        RedditAPI.getComments(permalink) { submission, comments in
            guard submission != nil else {
                return
            }
            var modifiedIndexPaths = [NSIndexPath]()
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

        
        tableView.registerClass(SubmissionCellView.self,
                forCellReuseIdentifier: "SubmissionCellView")
        tableView.registerClass(SubmissionImageCellView.self,
                forCellReuseIdentifier: "SubmissionImageCellView")
        tableView.registerClass(SubmissionLinkCellView.self,
                forCellReuseIdentifier: "SubmissionLinkCellView")
        tableView.registerClass(SubmissionSelfPostCellView.self,
                forCellReuseIdentifier: "SubmissionSelfPostCellView")
        tableView.registerClass(TextCommentCellView.self,
                forCellReuseIdentifier: "TextCommentCellView")
        tableView.registerClass(MoreCommentCellView.self,
                forCellReuseIdentifier: "MoreCommentCellView")
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
            return submissionCell(tableView, indexPath: indexPath)
        }
        return commentCell(tableView, indexPath: indexPath)
    }

    override func tableView(tableView: UITableView,
    		didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard indexPath.section == 1 else {
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
    
    private func submissionCell(tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell {
        let cell: SubmissionCellView
        if submission!.link?.previewUrl != nil {
            let imageCell = tableView.dequeueReusableCellWithIdentifier("SubmissionImageCellView",
           			forIndexPath: indexPath) as! SubmissionImageCellView
            imageCell.contentTappedDelegate = self
            cell = imageCell
        } else if submission!.link != nil {
            let linkCell = tableView.dequeueReusableCellWithIdentifier("SubmissionLinkCellView",
                    forIndexPath: indexPath) as! SubmissionLinkCellView
            linkCell.contentTappedDelegate = self
            cell = linkCell
        } else if submission!.selftextHtml != nil {
            let selfPostView = tableView.dequeueReusableCellWithIdentifier("SubmissionSelfPostCellView")
                	as! SubmissionSelfPostCellView
            cell = selfPostView
            selfPostView.contentBody.delegate = self
        } else {
            cell = tableView.dequeueReusableCellWithIdentifier("SubmissionCellView",
					forIndexPath: indexPath) as! SubmissionCellView
        }
        
        cell.setSubmission(submission!)
        return cell
    }
    
    private func commentCell(tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell {
        let comment = comments[indexPath.row]
        
        var cell: UITableViewCell
        
        if let textComment = comment as? TextComment {
            let textCommentCell = tableView.dequeueReusableCellWithIdentifier("TextCommentCellView")
                as! TextCommentCellView
            textCommentCell.comment = textComment
            textCommentCell.body.delegate = self
            
            let currentTime = Int(NSDate().timeIntervalSince1970)
            let timeDifference = currentTime - submission!.createdUTC

            textCommentCell.canSwipe = loginManager.account != nil &&
                    timeDifference < (30 * 6 * 24 * 3600)
            
            if traitCollection.forceTouchCapability == .Available {
                self.registerForPreviewingWithDelegate(self, sourceView: textCommentCell.body)
            }
            
            cell = textCommentCell
        } else {
            let moreComments = tableView.dequeueReusableCellWithIdentifier("MoreCommentCellView")!
                as! MoreCommentCellView
            moreComments.paddingConstraint.constant = CGFloat(comment.level * 8 + 8)
            cell = moreComments
        }
        
        cell.indentationLevel = comment.level
        
        return cell
    }

    // MARK: - Reddit operations

    private func loadMoreComments(comment: MoreComment, index: Int) {

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
        tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
        tableView.reloadRowsAtIndexPaths([NSIndexPath(forItem: index, inSection: 1)],
    			withRowAnimation: .Automatic)
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
        tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
        tableView.reloadRowsAtIndexPaths([NSIndexPath(forItem: index, inSection: 1)],
                withRowAnimation: .Automatic)
        tableView.endUpdates()
    }

    func contentTapped(submission: Submission) {

    }
    
    // MARK: BodyLabelDelegate
    func bodyLabel(link: Link) {
        if let preview = LinkUtils.viewControllerFor(link) {
            if preview is SFSafariViewController {
                parentViewController?.parentViewController?.presentViewController(preview, animated: true, completion: nil)
            } else if preview is UINavigationController {
                presentViewController(preview, animated: true, completion: nil)
            } else {
                navigationController?.pushViewController(preview, animated: true)
            }
        }
    }

    // MARK: - View Controller Previewing Delegate
    
    func previewingContext(previewingContext: UIViewControllerPreviewing,
                           viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let bodyLabel = previewingContext.sourceView as? BodyLabel else {
            return nil
        }
        if let (_, link) = bodyLabel.elementAtLocation(location) {
            return LinkUtils.viewControllerFor(link)
        }
        return nil
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing,
                           commitViewController viewControllerToCommit: UIViewController) {
        if viewControllerToCommit is SFSafariViewController {
            parentViewController?.parentViewController?.presentViewController(viewControllerToCommit, animated: true, completion: nil)
        } else if viewControllerToCommit is UINavigationController {
        	presentViewController(viewControllerToCommit, animated: true, completion: nil)
        } else {
            navigationController?.pushViewController(viewControllerToCommit, animated: true)
        }
    }
}
