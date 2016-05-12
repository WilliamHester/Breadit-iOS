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
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NavigationViewController.places.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    	delegate?.didNavigateTo(NavigationViewController.places[indexPath.row])
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) ->
        	UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("default")
        cell?.backgroundColor = UIColor.clearColor()
        if let textLabel = cell?.textLabel {
            textLabel.text = NavigationViewController.places[indexPath.row]
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
