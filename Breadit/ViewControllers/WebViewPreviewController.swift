//
//  WebViewPreviewController.swift
//  Breadit
//
//  Created by William Hester on 5/16/16.
//  Copyright © 2016 William Hester. All rights reserved.
//

import UIKit
import WebKit

class WebViewPreviewController: UIViewController {
    
    var webView: WKWebView!
    var link: Link!
    
    override func loadView() {
        title = "Preview"
        
        let doneButtom =  UIBarButtonItem(barButtonSystemItem: .Done, target: self,
                                          action: #selector(WebViewPreviewController.done(_:)))
        navigationItem.leftBarButtonItem = doneButtom
        
        webView = WKWebView()
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.loadRequest(NSURLRequest(URL: NSURL(string: link.url)!))
    }
    
    func done(sender: AnyObject?) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}
