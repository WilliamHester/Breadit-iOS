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

class SubmissionViewController: UITableViewController, UIViewControllerPreviewingDelegate {

    var detailViewController: CommentViewController? = nil
    var submissionStore: SubmissionStore! {
        didSet {
            let display = submissionStore.subredditDisplay
            title = display == "" ? "Front Page" : display
            submissionStore.refreshSubmissions(onRefresh)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Colors.backgroundColor

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        tableView.separatorColor = Colors.secondaryColor
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(SubmissionViewController.pullRefresh(_:)),
                forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl)
        
        tableView.registerClass(SubmissionCellView.self,
                forCellReuseIdentifier: "SubmissionCellView")
        tableView.registerClass(SubmissionImageCellView.self,
                forCellReuseIdentifier: "SubmissionImageCellView")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Submission loading

    private func onSubmissionsLoaded(oldCount: Int, _ newCount: Int) {
        tableView.beginUpdates()
        var indexPaths = [NSIndexPath]()
        for i in oldCount..<newCount {
            indexPaths.append(NSIndexPath(forRow: i, inSection: 0))
        }
        tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
        tableView.endUpdates()
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return submissionStore.submissions.count
    }

    override func tableView(tableView: UITableView,
            cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let submission = submissionStore.submissions[indexPath.row]
        let cell: SubmissionCellView
        if submission.getPreviewImage() != nil {
            cell = tableView.dequeueReusableCellWithIdentifier("SubmissionImageCellView",
                    forIndexPath: indexPath) as! SubmissionImageCellView
        } else {
            cell = tableView.dequeueReusableCellWithIdentifier("SubmissionCellView",
                    forIndexPath: indexPath) as! SubmissionCellView
        }
        
        if traitCollection.forceTouchCapability == .Available {
            self.registerForPreviewingWithDelegate(self, sourceView: cell)
        }

        if indexPath.item > submissionStore.submissions.count - 5 {
            submissionStore.loadSubmissions(onSubmissionsLoaded)
        }

		cell.setSubmission(submission)

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let commentsController = CommentViewController()
        commentsController.submission = submissionStore.submissions[indexPath.row]
        navigationController?.pushViewController(commentsController, animated: true)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func onRefresh(refreshed: Bool) {
        if refreshed {
        	self.tableView.reloadData()
        }
    }
    

    func pullRefresh(sender: UIRefreshControl) {
        submissionStore.refreshSubmissions { refreshed in
            self.onRefresh(refreshed)
            sender.endRefreshing()
        }
    }
    
    // MARK: - View Controller Previewing Delegate
    
    func previewingContext(previewingContext: UIViewControllerPreviewing,
            viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = tableView.indexPathForRowAtPoint(location) else {
            return nil
        }
        let viewController = CommentViewController()
        viewController.submission = submissionStore.submissions[indexPath.row]
        
        viewController.preferredContentSize = CGSize.zero

        return viewController
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing,
            commitViewController viewControllerToCommit: UIViewController) {
        showViewController(viewControllerToCommit, sender: self)
    }
}
