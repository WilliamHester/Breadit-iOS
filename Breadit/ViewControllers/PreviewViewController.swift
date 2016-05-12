//
//  PreviewViewController.swift
//  Breadit
//
//  Created by William Hester on 5/1/16.
//  Copyright © 2016 William Hester. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class PreviewViewController: UIViewController, UIScrollViewDelegate {
    
    var imageUrl: String!
    
    var scrollView: UIScrollView!
    var imageView: UIImageView!
    
    override func loadView() {
        uiView { v in
            v.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.8)
            let tapRecognizer = UITapGestureRecognizer(target: self,
                action: #selector(PreviewViewController.onTap(_:)))
            v.addGestureRecognizer(tapRecognizer)
            
            v.uiScrollView { v in
                self.scrollView = v
                v.delegate = self
                v.minimumZoomScale = 1.0
                v.maximumZoomScale = 6.0
                
                v.uiImageView { v in
                    self.imageView = v
                    v.contentMode = .ScaleAspectFit
                }.constrain { v in
                    v.widthAnchor.constraintEqualToAnchor(self.view.widthAnchor).active = true
                    v.heightAnchor.constraintEqualToAnchor(self.view.heightAnchor).active = true
                }
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
        
        Alamofire.request(.GET, imageUrl).responseImage { response in
            self.imageView.image = response.result.value
        }
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func onTap(gestureRecognizer: UITapGestureRecognizer) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
