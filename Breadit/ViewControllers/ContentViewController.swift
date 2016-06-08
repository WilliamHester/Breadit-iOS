//
//  ContentViewController.swift
//  Breadit
//
//  Created by William Hester on 5/27/16.
//  Copyright © 2016 William Hester. All rights reserved.
//

import Alamofire
import AlamofireImage
import UIKit
import SafariServices
import SwiftString

class ContentViewController: UITableViewController, SubmissionCellDelegate,
		UIViewControllerPreviewingDelegate, UIGestureRecognizerDelegate,
        ContentDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.registerClass(SubmissionCellView.self, forCellReuseIdentifier: "SubmissionCellView")
        tableView.registerClass(SubmissionImageCellView.self, forCellReuseIdentifier: "SubmissionImageCellView")
        tableView.registerClass(SubmissionLinkCellView.self, forCellReuseIdentifier: "SubmissionLinkCellView")
        tableView.registerClass(TextCommentCellView.self, forCellReuseIdentifier: "TextCommentCellView")
        tableView.registerClass(MoreCommentCellView.self, forCellReuseIdentifier: "MoreCommentCellView")

        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action:
            	#selector(ContentViewController.longPressed(_:)))
        longPressRecognizer.cancelsTouchesInView = true
        longPressRecognizer.delegate = self
        tableView.addGestureRecognizer(longPressRecognizer)
    }

    func done(sender: AnyObject?) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    func showActionsForRowAtIndexPath(indexPath: NSIndexPath) {

    }

    // MARK: - UIGestureRecognizerDelegate
    
    func longPressed(gestureRecognizer: UILongPressGestureRecognizer) {
        let point = gestureRecognizer.locationInView(tableView)
        guard let indexPath = tableView.indexPathForRowAtPoint(point) else {
            return
        }
        switch gestureRecognizer.state {
        case .Began:
            showActionsForRowAtIndexPath(indexPath)
        default:
            break
        }
    }

    // MARK: - SubmissionCellDelegate

    func contentTapped(submission: Submission) {
        showViewControllerFor(submission.link!)
    }
    
    func viewControllerFor(link: Link) -> UIViewController? {
        switch link.linkType {
        case .YouTube:
            let preview = YouTubePreviewViewController()
            preview.link = link
            return wrapInNavigationController(preview)
        case .Image(let imageType):
            if imageType == .Gif {
                let preview = GifViewController()
                preview.imageUrl = link.url
                preview.modalPresentationStyle = .OverFullScreen
                return preview
            }
            if imageType == .ImgurImage && (link.url.hasSuffix(".gifv") || link.url.hasSuffix(".gif")) {
                let preview = GifvViewController()
                preview.imageUrl = link.url
                if let range = preview.imageUrl.rangeOfString(".gif") {
                    preview.imageUrl.replaceRange(range, with: ".mp4")
                }
                preview.modalPresentationStyle = .OverFullScreen
                return preview
            }
            if imageType != .ImgurAlbum {
            	let preview = PreviewViewController()
            	preview.modalPresentationStyle = .OverFullScreen
            	preview.imageUrl = link.previewUrl
            	return preview
            }
            fallthrough
        case .Normal:
            return SFSafariViewController(URL: NSURL(string: link.url)!)
        case .Reddit(let redditType):
            switch redditType {
            case .Submission:
                let preview = CommentViewController()
                preview.permalink = link.id!
                return preview
            case .Subreddit:
                let preview = ListingViewController()
                preview.listingStore = SubmissionStore(subredditDisplay: link.id!)
                return preview
            case .User:
                let preview = ListingViewController()
                preview.listingStore = UserStore(username: link.id!)
                return preview
            case .RedditLive:
                break
            case .Messages:
                break
            case .Compose:
                break
            }
        }
        return nil
    }
    
    func wrapInNavigationController(viewController: UIViewController) -> UIViewController {
        let navigation = UINavigationController(rootViewController: viewController)
        navigation.modalTransitionStyle = .CoverVertical

        let menuButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done,
                target: viewController,
                action: #selector(ContentViewController.done(_:)))
        viewController.navigationItem.setLeftBarButtonItem(menuButton, animated: false)
        
        return navigation
    }
    
    func showViewControllerFor(link: Link) {
        if let vc = viewControllerFor(link) {
            showViewController(vc)
        }
    }
    
    func showViewController(viewController: UIViewController) {
        if viewController is ContentViewController {
            navigationController?.pushViewController(viewController, animated: true)
            return
        }
        var rootViewController: UIViewController = self
        while rootViewController.parentViewController != nil {
            rootViewController = rootViewController.parentViewController!
        }
        rootViewController.presentViewController(viewController, animated: true, completion: nil)
    }

    // MARK: - UIViewControllerPreviewingDelegate

    func previewingContext(previewingContext: UIViewControllerPreviewing,
                           viewControllerForLocation location: CGPoint) -> UIViewController? {
        return nil
    }

    func previewingContext(previewingContext: UIViewControllerPreviewing,
                           commitViewController viewControllerToCommit: UIViewController) {
        showViewController(viewControllerToCommit)
    }

    // MARK: - VotableDelegate

    func contentTapped(link: Link) {
        showViewControllerFor(link)
    }

    func vote(swipe: SwipeVoteType, forVotable votable: Votable, inView view: SwipeVoteView) {
        guard swipe != .None else {
            setUpVotableView(view, forVotable: votable)
            return
        }

        if swipe == .Right {
            if votable.voteStatus == .Upvoted {
                votable.voteStatus = .Neutral
            } else {
                votable.voteStatus = .Upvoted
            }
        } else if swipe == .Left {
            if votable.voteStatus == .Downvoted {
                votable.voteStatus = .Neutral
            } else {
                votable.voteStatus = .Downvoted
            }
        }

        setUpVotableView(view, forVotable: votable)

        if let textCommentCell = view.superview?.superview as? TextCommentCellView {
            textCommentCell.points.text = "\(votable.score) • \(shortTimeFromNow(votable))"
        } else if let submissionCell = view.superview?.superview as? SubmissionCellView {
            submissionCell.points.text = "\(votable.score) \(votable.score == 1 ? "point" : "points")"
        }

        RedditAPI.vote(votable)
    }

    func reusableRowForSubmission(submission: Submission, atIndexPath indexPath: NSIndexPath) -> SubmissionCellView {
        if submission.link?.previewUrl != nil {
            let imageCell = tableView.dequeueReusableCellWithIdentifier("SubmissionImageCellView",
                    forIndexPath: indexPath) as! SubmissionImageCellView
            setUpImageCellView(imageCell, forSubmission: submission)
            return imageCell
        } else if submission.link != nil {
            let linkCell = tableView.dequeueReusableCellWithIdentifier("SubmissionLinkCellView",
                    forIndexPath: indexPath) as! SubmissionLinkCellView
            setUpLinkCellView(linkCell, forSubmission: submission)
            return linkCell
        } else {
            return tableView.dequeueReusableCellWithIdentifier("SubmissionCellView",
                    forIndexPath: indexPath) as! SubmissionCellView
        }
    }

    func setUpRowForSubmission(submission: Submission, atIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = reusableRowForSubmission(submission, atIndexPath: indexPath)

        setUpSubmissionView(cell, forSubmission: submission)

        return cell
    }

    // MARK: - Custom UITableViewCells

    func setUpSubmissionView(view: SubmissionCellView, forSubmission submission: Submission) {
        view.swipableView.delegate = self
        view.submission = submission
        setUpVotableView(view.swipableView, forVotable: submission)

        view.swipableView.canSwipe = votableCanSwipe(submission)
        view.nsfw.hidden = !submission.over18
        view.points.text = "\(submission.score) \(submission.score == 1 ? "point" : "points")"
        view.title.text = submission.title.decodeHTML()
        view.authorAndSubreddit.text = "\(submission.author) • " +
                "/r/\(submission.subreddit.lowercaseString) • " +
                submission.domain

        let edited: String
        if let editedTime = submission.editedUTC {
            edited = " (edited \(NSDate(timeIntervalSince1970: Double(editedTime)).timeAgo()))"
        } else {
            edited = ""
        }

        let str: String = String(submission.numComments) + " " +
                (submission.numComments == 1 ? "comment" : "comments") + " " +
                NSDate(timeIntervalSince1970: Double(submission.createdUTC)).timeAgo() +
                edited
        view.comments.text = str
    }

    func setUpImageCellView(view: SubmissionImageCellView, forSubmission submission: Submission) {
        if let request = view.request {
            request.cancel()
            view.request = nil
        }
        view.delegate = self
        view.request = Alamofire.request(.GET, submission.link!.previewUrl!).responseImage { response in
            view.contentImage.image = response.result.value
            view.request = nil
        }
    }

    func setUpLinkCellView(view: SubmissionLinkCellView, forSubmission submission: Submission) {
        view.linkDescription.text = submission.link!.domain
        view.delegate = self

        if let request = view.request {
            request.cancel()
            view.request = nil
        }

        view.request = Alamofire.request(.GET, submission.thumbnail).responseImage { response in
            view.request = nil
            if response.result.isSuccess {
                view.thumbnailImage.image = response.result.value
            } else {
                view.thumbnailWidth.constant = 0
            }
        }
    }

    func setUpRowForComment(comment: Comment, atIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        if let textComment = comment as? TextComment {
            let textCommentCell = tableView.dequeueReusableCellWithIdentifier("TextCommentCellView")
                    as! TextCommentCellView
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

    func setUpTextCommentView(view: TextCommentCellView, forComment comment: TextComment) {
        setUpVotableView(view.swipableView, forVotable: comment)

        view.swipableView.canSwipe = votableCanSwipe(comment)
        view.swipableView.delegate = self
        view.swipableView.votable = comment

        view.body.delegate = self
        if traitCollection.forceTouchCapability == .Available {
            self.registerForPreviewingWithDelegate(self, sourceView: view.body)
        }

        view.paddingConstraint.constant = CGFloat(comment.level * 8 + 8)
        view.author.text = comment.author

        view.points.text = "\(comment.score) • \(shortTimeFromNow(comment))"

        if let flairText = comment.authorFlairText {
            view.flair.text = flairText
            view.flair.hidden = false
        } else {
            view.flair.text = ""
            view.flair.hidden = true
        }

        if comment.hidden {
            view.body.attributedText = NSMutableAttributedString(string: "Comment hidden",
                    attributes: [
                            NSForegroundColorAttributeName: Colors.secondaryTextColor,
                    ])
        } else {
            view.body.attributedText =
                    HTMLParser(escapedHtml: comment.bodyHTML, font: UIFont.systemFontOfSize(13)).attributedString
        }
    }

    func setUpVotableView(view: SwipeVoteView, forVotable votable: Votable) {
        if votable.voteStatus == .Upvoted {
            view.left.backgroundColor = upvoteColor
            view.right.backgroundColor = Colors.backgroundColor
        } else if votable.voteStatus == .Downvoted {
            view.left.backgroundColor = Colors.backgroundColor
            view.right.backgroundColor = downvoteColor
        } else {
            view.left.backgroundColor = Colors.backgroundColor
            view.right.backgroundColor = Colors.backgroundColor
        }
    }

    func setUpMoreCommentView(view: MoreCommentCellView, forComment comment: Comment) {
        view.paddingConstraint.constant = CGFloat(comment.level * 8 + 8)
    }

    private func votableCanSwipe(votable: Votable) -> Bool {
        return LoginManager.singleton.account != nil && !votable.archived
    }

    private func shortTimeFromNow(votable: Votable) -> String {
        let currentTime = Int(NSDate().timeIntervalSince1970)
        let postTime = votable.createdUTC
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
