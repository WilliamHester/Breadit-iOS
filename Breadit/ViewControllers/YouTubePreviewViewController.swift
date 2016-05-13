//
//  YouTubePreviewViewController.swift
//  Breadit
//
//  Created by William Hester on 5/12/16.
//  Copyright © 2016 William Hester. All rights reserved.
//

import UIKit
import youtube_ios_player_helper

class YouTubePreviewViewController: UIViewController, YTPlayerViewDelegate {

    private var playerView: YTPlayerView!

    var link: Link!

    override func loadView() {
        uiView { v in
            v.backgroundColor = UIColor.blackColor()
        	v.uiStackView { v in
            	v.axis = .Vertical
            	self.playerView = YTPlayerView()
            	self.playerView.delegate = self
            	self.playerView.hidden = true
            	v.addChild(self.playerView)
            }.constrain { v in
                v.leftAnchor.constraintEqualToAnchor(self.view.leftAnchor).active = true
                v.rightAnchor.constraintEqualToAnchor(self.view.rightAnchor).active = true
                v.topAnchor.constraintEqualToAnchor(self.view.topAnchor).active = true
                v.bottomAnchor.constraintEqualToAnchor(self.view.bottomAnchor).active = true
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "YouTube"
        
        playerView.topAnchor.constraintEqualToAnchor(topLayoutGuide.bottomAnchor)
        
        let doneButtom =  UIBarButtonItem(barButtonSystemItem: .Done, target: self,
    			action: #selector(YouTubePreviewViewController.done(_:)))
        navigationItem.leftBarButtonItem = doneButtom

        playerView.loadWithVideoId(link.id!)
    }
    
    func done(obj: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    func playerViewDidBecomeReady(playerView: YTPlayerView) {
        playerView.hidden = false
    }
    
    func playerViewPreferredWebViewBackgroundColor(playerView: YTPlayerView) -> UIColor {
        return UIColor.clearColor()
    }
}
