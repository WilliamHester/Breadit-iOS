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

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    let submissionStore = SubmissionStore()


    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 180

        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }

        submissionStore.loadSubmissions(onSubmissionsLoaded)
    }

    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
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

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
//            if let indexPath = self.tableView.indexPathForSelectedRow {
//                let object = objects[indexPath.row] as! NSDate
//                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
//                controller.detailItem = object
//                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
//                controller.navigationItem.leftItemsSupplementBackButton = true
//            }
        }
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
        let cell = tableView.dequeueReusableCellWithIdentifier("SubmissionCell",
        		forIndexPath: indexPath) as! SubmissionCell

        if indexPath.item > submissionStore.submissions.count - 5 {
            submissionStore.loadSubmissions(onSubmissionsLoaded)
        }

        let submission = submissionStore.submissions[indexPath.row]
        cell.title.text = submission.title
        cell.author.text = submission.author
        cell.content.image = nil
        if let previewImage = submission.getPreviewImage() {
            cell.content.hidden = false
            Alamofire.request(.GET, previewImage).responseImage { response in
                cell.content.image = response.result.value
            }
        } else {
            cell.content.hidden = true
        }
        return cell
    }

    @IBAction func pullRefresh(sender: UIRefreshControl) {
        submissionStore.refreshSubmissions { refreshed in
            if refreshed {
                self.tableView.reloadData()
            }
            sender.endRefreshing()
        }
    }
}
