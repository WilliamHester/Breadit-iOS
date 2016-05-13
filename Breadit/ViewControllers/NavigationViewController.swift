//
//  NavigationViewController.swift
//  Breadit
//
//  Created by William Hester on 5/1/16.
//  Copyright © 2016 William Hester. All rights reserved.
//

import UIKit

class NavigationViewController: UITableViewController {
    
    private static let places = ["Home", "Inbox", "Account", "Friends", "Submit", "Settings"]
    
    var delegate: NavigationDelegate?
    var subredditStore: SubredditStore!
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Colors.backgroundColor
        
        let height = UIApplication.sharedApplication().statusBarFrame.height
        tableView.contentInset = UIEdgeInsetsMake(height, 0, 0, 0)
        tableView.separatorColor = Colors.secondaryColor
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "default")
        
        subredditStore.loadSubreddits {
            self.tableView.reloadData()
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return NavigationViewController.places.count
        } else {
            return subredditStore.subreddits.count
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    	delegate?.didNavigateTo(NavigationViewController.places[indexPath.row])
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) ->
        	UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("default")
        cell?.backgroundColor = UIColor.clearColor()
        if let textLabel = cell?.textLabel {
            if indexPath.section == 0 {
            	textLabel.text = NavigationViewController.places[indexPath.row]
            } else {
                textLabel.text = subredditStore.subreddits[indexPath.row].displayName.lowercaseString
            }
            textLabel.textColor = Colors.textColor
        }
        return cell!
    }
    
}

enum NavigationPlace {
    case Subreddit(String)
    case Inbox
    case Account
    case Friends
    case Submit
    case Settings
}

protocol NavigationDelegate {
    func didNavigateTo(place: String)
}
