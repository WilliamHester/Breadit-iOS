//
//  MasterViewController.swift
//  Breadit
//
//  Created by William Hester on 4/22/16.
//  Copyright © 2016 William Hester. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import NSDate_TimeAgo

class ListingViewController: ContentViewController {

    var canLoad = false
    var listingStore: ListingStore! {
        didSet {
            canLoad = true
            title = listingStore.display
            listingStore.refreshContent(onRefresh)

            if tableView != nil {
                tableView.reloadData()
                tableView.setContentOffset(tableView.contentOffset, animated: false)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Colors.backgroundColor

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        tableView.separatorColor = Colors.secondaryColor
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(ListingViewController.pullRefresh(_:)),
                forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl)
        tableView.sendSubviewToBack(refreshControl)
        
        let button = UIBarButtonItem(barButtonSystemItem: .Organize, target: self,
        		action: #selector(ListingViewController.sort(_:)))
        navigationItem.setRightBarButtonItem(button, animated: false)
    }
    
    func sort(obj: AnyObject?) {
        print("clicked")
    }
    
    // MARK: - Submission loading

    private func onContentLoaded(oldCount: Int, _ newCount: Int) {
        guard newCount > oldCount else {
            return
        }
        self.canLoad = true
        
        UIView.setAnimationsEnabled(false)
        tableView.beginUpdates()
        var indexPaths = [NSIndexPath]()
        for i in oldCount..<newCount {
            indexPaths.append(NSIndexPath(forRow: i, inSection: 0))
        }
        tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .None)
        tableView.endUpdates()
        tableView.setContentOffset(tableView.contentOffset, animated: true)
        UIView.setAnimationsEnabled(true)
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listingStore.content.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row + 5 > listingStore.content.count && canLoad {
            listingStore.loadContent(onContentLoaded)
            canLoad = false
        }

        if let textComment = listingStore.content[indexPath.row] as? TextComment {
            return setUpRowForComment(textComment, atIndexPath: indexPath)
        } else if let submission = listingStore.content[indexPath.row] as? Submission {
            return setUpRowForSubmission(submission, atIndexPath: indexPath)
        }

        // Very bad, but should never happen
        return UITableViewCell()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let commentsController = CommentViewController()
        setUpCommentViewController(commentsController, forVotable: listingStore.content[indexPath.row])
        navigationController?.pushViewController(commentsController, animated: true)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func onRefresh(refreshed: Bool) {
        if refreshed {
            self.tableView.reloadData()
        }
    }

    func pullRefresh(sender: UIRefreshControl) {
        listingStore.refreshContent { refreshed in
            self.onRefresh(refreshed)
            sender.endRefreshing()
            self.canLoad = refreshed
        }
    }

    func setUpCommentViewController(vc: CommentViewController, forVotable votable: Votable) -> Bool {
        if let textComment = votable as? TextComment {
            guard let linkURL = textComment.linkURL else {
                return false
            }
            let link = Link(link: linkURL)
            if let linkID = link.id {
                vc.permalink = linkID
            } else {
                return false
            }
        } else if let submission = votable as? Submission {
            vc.permalink = submission.permalink
            vc.submission = submission
        }
        return true
    }
    
    // MARK: - View Controller Previewing Delegate
    
    override func previewingContext(previewingContext: UIViewControllerPreviewing,
            viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = tableView.indexPathForRowAtPoint(location) else {
            return nil
        }
        
        let viewRectInTableView = tableView.convertRect(view.frame, fromCoordinateSpace: view.superview!)
        previewingContext.sourceRect = viewRectInTableView

        let viewController = CommentViewController()

        guard setUpCommentViewController(viewController, forVotable: listingStore.content[indexPath.row]) else {
            return nil
        }
        
        viewController.preferredContentSize = CGSize.zero

        return viewController
    }
}
