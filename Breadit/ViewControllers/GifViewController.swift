//
//  PreviewViewController.swift
//  Breadit
//
//  Created by William Hester on 5/30/16.
//  Copyright © 2016 William Hester. All rights reserved.
//

import UIKit
import Alamofire
import FLAnimatedImage

class GifViewController: UIViewController {
    
    var imageUrl: String!

    private var imageView: FLAnimatedImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.8)

        imageView = FLAnimatedImageView()
        
        view.addSubview(imageView)

        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTap(_:)))
        view.addGestureRecognizer(tapRecognizer)
        
        Alamofire.request(.GET, imageUrl).responseData { response in
            let image = FLAnimatedImage(animatedGIFData: response.data)
        	self.fixFrame(image.size)
            self.imageView.animatedImage = image
            self.imageView.center = self.view.center
        }
    }
    
    private func fixFrame(imageSize: CGSize) {
        var imageFrame = view.frame
        let frameSize = imageFrame.size
        let frameAspectRatio = frameSize.width / frameSize.height
        let imageAspectRatio = imageSize.width / imageSize.height
        
        if frameAspectRatio > imageAspectRatio {
            let heightRatio = frameSize.height / imageSize.height
            imageFrame.size.width = heightRatio * imageSize.width
        } else {
            let widthRatio = frameSize.width / imageSize.width
            imageFrame.size.height = widthRatio * imageSize.height
        }
        imageView.frame = imageFrame
    }
    
    func onTap(gestureRecognizer: UITapGestureRecognizer) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
