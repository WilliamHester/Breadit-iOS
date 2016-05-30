//
//  PreviewViewController.swift
//  Breadit
//
//  Created by William Hester on 5/29/16.
//  Copyright © 2016 William Hester. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import Player

class GifvViewController: UIViewController, PlayerDelegate {

    var imageUrl: String!
    var player: Player!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.8)
        
        player = Player()
        player.delegate = self
        
        addChildViewController(player)
        view.addSubview(player.view)
        player.didMoveToParentViewController(self)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTap(_:)))
        view.addGestureRecognizer(tapRecognizer)
        
        player.view.frame = view.frame
        player.setUrl(NSURL(string: imageUrl)!)
    }
    
    func onTap(gestureRecognizer: UITapGestureRecognizer) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    func playerReady(player: Player) {
        player.playFromBeginning()
    }

    func playerPlaybackStateDidChange(player: Player) {
    }

    func playerBufferingStateDidChange(player: Player) {
    }

    func playerPlaybackWillStartFromBeginning(player: Player) {
    }

    func playerPlaybackDidEnd(player: Player) {
        player.playFromBeginning()
    }
}
