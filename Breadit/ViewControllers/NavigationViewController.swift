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
        let place: NavigationPlace
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                place = .Subreddit("")
            case 1:
                place = .Inbox
            case 2:
                place = .Account
            case 3:
                place = .Friends
            case 4:
                place = .Submit
            case 5:
                place = .Settings
            default:
                place = .Subreddit("")
            }
        } else {
            place = .Subreddit(subredditStore.subreddits[indexPath.row].displayName)
        }
        delegate?.didNavigateTo(place)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) ->
        	UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("default")
        cell?.backgroundColor = UIColor.clearColor()
        cell?.selectedBackgroundView = UIView()
        cell?.selectedBackgroundView?.backgroundColor = UIColor.darkGrayColor()
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
    func didNavigateTo(place: NavigationPlace)
}
