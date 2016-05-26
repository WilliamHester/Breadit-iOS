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
		UIViewControllerPreviewingDelegate {

    var submission: Submission?
    var permalink: String? {
        didSet {
            self.configureView(permalink!)
        }
    }
    var comments = [Comment]()

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
            cell = tableView.dequeueReusableCellWithIdentifier("SubmissionImageCellView",
           			forIndexPath: indexPath) as! SubmissionImageCellView
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
        
        var cell: CommentCellView
        
        if let textComment = comment as? TextComment {
            let textCommentCell = tableView.dequeueReusableCellWithIdentifier("TextCommentCellView")
                as! TextCommentCellView
            textCommentCell.paddingConstraint.constant = CGFloat(comment.level * 8 + 8)
            textCommentCell.author.text = textComment.author
            let parsedText = HTMLParser(
                escapedHtml: textComment.body_html,
                font: textCommentCell.body.font!
            )
            textCommentCell.body.attributedText = parsedText.attributedString
            textCommentCell.body.delegate = self
            
            textCommentCell.pointsAndTime.text = "\(textComment.score) • " +
            		"\(shortTimeFromNow(textComment))"
            
            if let flair = textComment.author_flair_text {
                textCommentCell.hidden = false
                textCommentCell.flair.text = flair
            } else {
                textCommentCell.flair.hidden = true
            }
            
            if textComment.hidden {
                textCommentCell.hide()
            }
            
            if traitCollection.forceTouchCapability == .Available {
                self.registerForPreviewingWithDelegate(self, sourceView: textCommentCell.body)
            }
            
            cell = textCommentCell
        } else {
            cell = tableView.dequeueReusableCellWithIdentifier("MoreCommentCellView")!
                as! MoreCommentCellView
            cell.paddingConstraint.constant = CGFloat(comment.level * 8 + 8)
        }
        
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
    
    private func shortTimeFromNow(textComment: TextComment) -> String {
        let currentTime = Int(NSDate().timeIntervalSince1970)
        let postTime = textComment.created_utc
        let difference = max(currentTime - postTime, 0)
        var time: String
        if (difference / 31536000 > 0) {
            time = "\(difference / 31536000)y"
        } else if (difference / 2592000 > 0) {
            time = "\(difference / 2592000)mo"
        } else if (difference / 604800 > 0) {
            time = "\(difference / 604800)w"
        } else if (difference / 86400 > 0) {
            time = "\(difference / 86400)d"
        } else if (difference / 3600 > 0) {
            time = "\(difference / 3600)h"
        } else if (difference / 60 > 0) {
            time = "\(difference / 60)m"
        } else {
            time = "\(difference)s"
        }
        return time
    }
}
