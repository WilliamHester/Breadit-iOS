//
//  NavigationViewController.swift
//  Breadit
//
//  Created by William Hester on 5/1/16.
//  Copyright © 2016 William Hester. All rights reserved.
//

import UIKit

class NavigationViewController: UITableViewController, UISearchBarDelegate {
    
    private static let places = ["Home", "Inbox", "Account", "Friends", "Submit", "Settings"]
    
    var delegate: NavigationDelegate?
    var subredditStore: SubredditStore!
    var searchBar: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Colors.backgroundColor
        
        let height = UIApplication.sharedApplication().statusBarFrame.height
        tableView.contentInset = UIEdgeInsetsMake(height, 0, 0, 0)
        tableView.separatorColor = Colors.secondaryColor
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "default")
        
        setUpSearchView()
        
        subredditStore.loadSubreddits {
            self.tableView.reloadData()
        }
    }
    
    private func setUpSearchView() {
        searchBar = UISearchBar()
        searchBar.autoresizingMask = .FlexibleWidth
        searchBar.searchBarStyle = .Minimal
        searchBar.tintColor = Colors.secondaryTextColor
        searchBar.sizeToFit()
        
        searchBar.delegate = self
        
        tableView.tableHeaderView = searchBar
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        var text = searchBar.text!
        if let range = text.rangeOfString("/r/") where range.startIndex == text.startIndex {
            text.replaceRange(range, with: "")
            delegate?.didNavigateTo(.Subreddit(text))
        } else if let range = text.rangeOfString("r/") where range.startIndex == text.startIndex {
            text.replaceRange(range, with: "")
            delegate?.didNavigateTo(.Subreddit(text))
        } else {
            delegate?.didNavigateTo(.Search(text))
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
    
    func stopSearching() {
        if searchBar.isFirstResponder() {
        	searchBar.resignFirstResponder()
        }
    }
    
    override func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        stopSearching()
    }
}

enum NavigationPlace {
    case Subreddit(String)
    case Search(String)
    case Inbox
    case Account
    case Friends
    case Submit
    case Settings
}

protocol NavigationDelegate {
    func didNavigateTo(place: NavigationPlace)
}
