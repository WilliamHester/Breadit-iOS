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

class CommentViewController: UITableViewController, BodyLabelDelegate {

    var submission: Submission! {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    var comments = [Comment]()

    func configureView() {
        RedditAPI.getComments(submission.permalink) { _, comments in
            self.comments = comments
            self.tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
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

        self.configureView()
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
        if submission.getPreviewImage() != nil {
            cell = tableView.dequeueReusableCellWithIdentifier("SubmissionImageCellView",
           			forIndexPath: indexPath) as! SubmissionImageCellView
        } else if submission.selftextHtml != nil {
            let selfPostView = tableView.dequeueReusableCellWithIdentifier("SubmissionSelfPostCellView")
                	as! SubmissionSelfPostCellView
            cell = selfPostView
            selfPostView.contentBody.delegate = self
        } else {
            cell = tableView.dequeueReusableCellWithIdentifier("SubmissionCellView",
					forIndexPath: indexPath) as! SubmissionCellView
        }
        
        cell.setSubmission(submission)
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
            textCommentCell.body.links = parsedText.links
            textCommentCell.body.delegate = self
            
            if textComment.hidden {
                textCommentCell.hide()
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

        tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
        tableView.reloadRowsAtIndexPaths([NSIndexPath(forItem: index, inSection: 1)], withRowAnimation: .Automatic)
        
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

        tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
        tableView.reloadRowsAtIndexPaths([NSIndexPath(forItem: index, inSection: 1)], withRowAnimation: .Automatic)
    }
    
    // MARK: BodyLabelDelegate
    func bodyLabel(link: Link) {
        switch link.linkType {
        case .Normal:
            break
        case .YouTube:
            let preview = YouTubePreviewViewController()
            let navigation = UINavigationController(rootViewController: preview)
            navigation.navigationBar.barStyle = .Black
            navigation.modalTransitionStyle = .CoverVertical
            preview.link = link
            navigationController?.presentViewController(navigation, animated: true, completion: nil)
        case .Image(let imageType):
            let preview = PreviewViewController()
        	preview.modalPresentationStyle = .OverFullScreen
        	preview.imageUrl = link.previewUrl
        	presentViewController(preview, animated: true, completion: nil)
            switch imageType {
            case .Normal:
                break
            case .ImgurImage:
                break
            case .ImgurAlbum:
                break
            case .ImgurGallery:
                break
            case .Gfycat:
                break
            case .DirectGfy:
                break
            case .Gif:
                break
            }
        case .Reddit(let redditType):
            switch redditType {
            case .Submission:
                break
            case .Subreddit:
                break
            case .User:
                break
            case .RedditLive:
                break
            case .Messages:
                break
            case .Compose:
                break
            }
        }
    }
}
