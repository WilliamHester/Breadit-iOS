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
    let submissionStore = SubmissionStore()
    
    var seen: Float = 0
    var sum: Float {
        didSet {
            title = "\(sum / seen)"
        }
    }
    
    init() {
        self.sum = 0
        super.init(style: .Plain)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(SubmissionViewController.pullRefresh(_:)),
                forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl)
        
        tableView.registerClass(SubmissionCellView.self,
                forCellReuseIdentifier: "SubmissionCellView")
        tableView.registerClass(SubmissionImageCellView.self,
                forCellReuseIdentifier: "SubmissionImageCellView")

        submissionStore.loadSubmissions(onSubmissionsLoaded)
        
        title = "Front Page"
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
        if let previewImage = submission.getPreviewImage() {
            cell = tableView.dequeueReusableCellWithIdentifier("SubmissionImageCellView",
                    forIndexPath: indexPath) as! SubmissionImageCellView
            Alamofire.request(.GET, previewImage).responseImage { response in
                (cell as! SubmissionImageCellView).contentImage.image = response.result.value
            }
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

        cell.title.text = submission.title.decodeHTML()
        cell.authorAndPoints.text = "\(submission.author) \(submission.score) " +
                "\(submission.score == 1 ? "point" : "points")"
        cell.subreddit.text = submission.subreddit.lowercaseString
        cell.relativeDate.text = NSDate(timeIntervalSince1970: Double(submission.createdUTC))
                .timeAgo()
        cell.comments.text = "\(submission.numComments) " +
                "\(submission.numComments == 1 ? "comment" : "comments")"
        cell.domain.text = submission.domain

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let commentsController = CommentViewController()
        commentsController.submission = submissionStore.submissions[indexPath.row]
        navigationController?.pushViewController(commentsController, animated: true)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    func pullRefresh(sender: UIRefreshControl) {
        submissionStore.refreshSubmissions { refreshed in
            if refreshed {
                self.tableView.reloadData()
            }
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
