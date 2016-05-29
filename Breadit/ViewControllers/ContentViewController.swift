//
//  ContentViewController.swift
//  Breadit
//
//  Created by William Hester on 5/27/16.
//  Copyright © 2016 William Hester. All rights reserved.
//

import UIKit
import SafariServices

class ContentViewController: UITableViewController, SubmissionCellDelegate,
		UIViewControllerPreviewingDelegate, UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

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
                let preview = SubmissionViewController()
                preview.submissionStore = SubmissionStore(subredditDisplay: link.id!)
                return preview
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
        if !(viewController is SFSafariViewController) &&
            	!(viewController is UINavigationController) &&
            	!(viewController is PreviewViewController) {
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
}
