//
//  DetailViewController.swift
//  Breadit
//
//  Created by William Hester on 4/22/16.
//  Copyright © 2016 William Hester. All rights reserved.
//

import UIKit

class CommentViewController: UITableViewController, UIViewControllerPreviewingDelegate,
		BodyLabelDelegate {

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

        title = "Comments"

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        tableView.separatorStyle = .None

        tableView.registerClass(TextCommentCellView.self,
                                forCellReuseIdentifier: "TextCommentCellView")
        tableView.registerClass(MoreCommentCellView.self,
                                forCellReuseIdentifier: "MoreCommentCellView")

        self.configureView()
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }

    override func tableView(tableView: UITableView,
                            cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let comment = comments[indexPath.row]

        var cell: CommentCellView

        if let textComment = comment as? TextComment {
            let textCommentCell = tableView.dequeueReusableCellWithIdentifier("TextCommentCellView")
                as! TextCommentCellView
            textCommentCell.author.text = textComment.author
            let parsedText = HTMLParser(
                escapedHtml: textComment.body_html,
                font: textCommentCell.body.font!
            )
            textCommentCell.body.attributedText = parsedText.attributedString
            textCommentCell.body.links = parsedText.links
            textCommentCell.body.delegate = self
            cell = textCommentCell
        } else {
            cell = tableView.dequeueReusableCellWithIdentifier("MoreCommentCellView")!
                	as! MoreCommentCellView
        }

        cell.paddingConstraint.constant = CGFloat(comment.level * 8 + 8)

        return cell
    }

    override func tableView(tableView: UITableView,
    		didSelectRowAtIndexPath indexPath: NSIndexPath) {
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
                indexPaths.append(NSIndexPath(forItem: i, inSection: 0))
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
    }

    private func expandComment(comment: TextComment, index: Int) {
        comment.hidden = false

        var indexPaths = [NSIndexPath]()
        if comment.replies!.count > 0 {
            for i in 1...comment.replies!.count {
                indexPaths.append(NSIndexPath(forRow: i + index, inSection: 0))
            }
            comments.insertContentsOf(comment.replies!, at: index + 1)
        }
        comment.replies = nil
        tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
    }

    // MARK: - ViewControllerPreviewingDelegate

    func previewingContext(previewingContext: UIViewControllerPreviewing,
                           viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = tableView.indexPathForRowAtPoint(location) else {
            return nil
        }
        let viewController = UIViewController()
//        let rawRect = tableView.rectForRowAtIndexPath(indexPath)
//        let rect = CGRectOffset(rawRect, -tableView.contentOffset.x, -tableView.contentOffset.y)
//
//        let cell = tableView.cellForRowAtIndexPath(indexPath)
        

        viewController.preferredContentSize = CGSize.zero

        return nil
    }

    func previewingContext(previewingContext: UIViewControllerPreviewing,
                           commitViewController viewControllerToCommit: UIViewController) {
        showViewController(viewControllerToCommit, sender: self)
    }
    
    // MARK: BodyLabelDelegate
    func bodyLabel(link: Link) {
//        UIApplication.sharedApplication().openURL(NSURL(string: link.url)!)
        let preview = PreviewViewController()
        preview.modalPresentationStyle = .OverCurrentContext
        preview.imageUrl = link.previewUrl
        parentViewController?.parentViewController?.presentViewController(preview, animated: true, completion: nil)
        switch link.linkType {
        case .Normal:
            break
        case .YouTube:
            break
        case .Image(let imageType):
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
