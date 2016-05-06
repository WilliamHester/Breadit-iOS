//
//  LoginViewController.swift
//  Breadit
//
//  Created by William Hester on 5/4/16.
//  Copyright © 2016 William Hester. All rights reserved.
//

import UIKit
import WebKit

class LoginViewController: UIViewController, WKNavigationDelegate {
    
    var webView: WKWebView!
    let state = NSUUID().UUIDString
    
    override func loadView() {
        title = "Log in"
        
        webView = WKWebView()
        
        view = webView
        
        webView.navigationDelegate = self

        webView.loadRequest(NSURLRequest(URL: NSURL(string: buildUrl())!))
    }
    
    private func buildUrl() -> String {
        var url = "https://www.reddit.com/api/v1/authorize.compact"
        url += "?client_id=\(Keys.redditClientId)"
        url += "&response_type=code"
        url += "&state=\(state)"
        url += "&duration=permanent"
        url += "&redirect_uri=\(Keys.redditRedirectUrl)"
        url += "&scope=identity,edit,flair,history,modconfig,modflair,modlog,modposts,modwiki," +
            	"mysubreddits,privatemessages,read,report,save,submit,subscribe,vote,wikiedit" +
        		",wikiread"
        return url
    }
    
    func webView(webView: WKWebView,
                 didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        if let stringUrl = webView.URL?.absoluteString where
            stringUrl.hasPrefix(Keys.redditRedirectUrl) {
            webView.URL!.query
            var dict = [String: String]()
            for item in (webView.URL!.query?.componentsSeparatedByString("&"))! {
                let keyValuePair = item.componentsSeparatedByString("=")
                dict[keyValuePair[0]] = keyValuePair[1]
            }
            if let code = dict["code"] {
                RedditAPI.getToken(code) { account in
                    if let loggedInTempAccount = account {
                        RedditAPI.getDetails(loggedInTempAccount) { success in

                        }
                    } else {
                        
                    }
                }
            }
        }
    }
    
}
