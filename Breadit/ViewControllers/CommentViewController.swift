//
//  DetailViewController.swift
//  Breadit
//
//  Created by William Hester on 4/22/16.
//  Copyright © 2016 William Hester. All rights reserved.
//

import UIKit

class CommentViewController: UITableViewController {

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
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        tableView.separatorStyle = .None
        
        
        tableView.registerClass(TextCommentCellView.self,
                                forCellReuseIdentifier: "TextCommentCellView")
        tableView.registerClass(MoreCommentCellView.self,
                                forCellReuseIdentifier: "MoreCommentCellView")

        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
        
        title = "Comments"
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
            textCommentCell.body.attributedText = HTMLParser(escapedHtml: textComment.body_html).attributedString
            cell = textCommentCell
        } else {
            cell = tableView.dequeueReusableCellWithIdentifier("MoreCommentCellView")!
                	as! MoreCommentCellView
        }
        
        cell.paddingConstraint.constant = CGFloat(comment.level * 8 + 4)
        
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

}
