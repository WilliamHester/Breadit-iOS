//
//  ContentViewController.swift
//  Breadit
//
//  Created by William Hester on 5/27/16.
//  Copyright © 2016 William Hester. All rights reserved.
//

import UIKit
import SafariServices

class ContentViewController: UITableViewController, SubmissionCellDelegate, UIViewControllerPreviewingDelegate {

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
    }

    func done(sender: AnyObject?) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK: - SubmissionCellDelegate

    func contentTapped(submission: Submission) {
        showViewControllerFor(submission.link!)
    }
    
    func viewControllerFor(link: Link) -> UIViewController? {
        switch link.linkType {
        case .Normal:
            let preview = SFSafariViewController(URL: NSURL(string: link.url)!)
            preview.modalTransitionStyle = .CoverVertical
            preview.modalPresentationStyle = .OverCurrentContext
            return preview
        case .YouTube:
            let preview = YouTubePreviewViewController()
            preview.link = link
            return wrapInNavigationController(preview)
        case .Image(_):
            let preview = PreviewViewController()
            preview.modalPresentationStyle = .OverFullScreen
            preview.imageUrl = link.previewUrl
            return preview
        case .Reddit(let redditType):
            switch redditType {
            case .Submission:
                let preview = CommentViewController()
                preview.permalink = link.id!
                return wrapInNavigationController(preview)
            case .Subreddit:
                let preview = SubmissionViewController()
                preview.submissionStore = SubmissionStore(subredditDisplay: link.id!)
                return wrapInNavigationController(preview)
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
        navigation.navigationBar.barStyle = .BlackTranslucent
        navigation.navigationBar.tintColor = Colors.secondaryTextColor
        
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
