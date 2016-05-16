//
//  RedditAPI.swift
//  Breadit
//
//  Created by William Hester on 4/23/16.
//  Copyright © 2016 William Hester. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import Realm
import RealmSwift

struct RedditAPI {
    
    static var loginManager: LoginManager!
    static let realm = try! Realm()

    static func getSubmissions(subreddit: String, after: String = "", callback: ([Submission]) -> ()) {
        let subString = subreddit.length > 0 ? "r/" + subreddit : subreddit
        let request = RedditRequest(subString, queries: ["after" : after])
        var submissions = [Submission]()
        request.getJson { json in
            if let subs = json["data"]["children"].array {
                for sub in subs {
                    submissions.append(Submission(json: sub["data"]))
                }
                callback(submissions)
            } else {
                callback([])
            }
        }
    }
    
    static func getComments(permalink: String, callback: (Submission, [Comment]) -> ()) {
        let request = RedditRequest(permalink)
        request.getJson { json in
            let submission = Submission(json: json[0]["data"]["children"][0]["data"])

            var comments = [Comment]()
            if let commentsJson = json[1]["data"]["children"].array {
                for commentJson in commentsJson {
                    if commentJson["kind"] == "more" {
                        comments.append(MoreComment(json: commentJson["data"], level: 0))
                    } else {
                        comments.append(TextComment(json: commentJson["data"], level: 0))
                    }
                }
            }

            // Parse the comments into a list of comments with levels
            var resultComments = [Comment]()
            for comment in comments {
                var stack = [Comment]()
                stack.append(comment)
                while !stack.isEmpty {
                    let root = stack.removeFirst()
                    resultComments.append(root)

                    if let textRoot = root as? TextComment {
                    	stack = textRoot.replies! + stack
                        textRoot.replies = nil // remove the replies; they're no longer needed
                    }
                }
            }

            callback(submission, resultComments)
        }
    }
    
    static func getMySubreddits(callback: ([Subreddit]) ->()) {
        getSubreddits("mine", after: "", accumulator: [], callback: callback)
    }
    
    static func getDefaultSubreddits(callback: ([Subreddit]) -> ()) {
        getSubreddits("default", after: "", accumulator: [], callback: callback)
    }
    
    static func getSubreddits(type: String, after: String, accumulator: [Subreddit], callback: ([Subreddit]) -> ()) {
        var subs = accumulator
        
        let request = RedditRequest("subreddits/\(type)", queries: ["after": after])
        request.getJson { json in
            if let subreddits = json["data"]["children"].array {
                if subreddits.count == 0 {
                    callback(accumulator)
                    return
                }
                for subreddit in subreddits {
                    subs.append(Subreddit(json: subreddit["data"], isDefault: "default" == type))
                }
                try! realm.write {
                    for subreddit in subs {
                        realm.add(subreddit, update: true)
                    }
                }
                getSubreddits(type, after: subreddits.last!["data"]["name"].string!, accumulator: subs, callback: callback)
            } else {
                callback([])
            }
        }
    }
    
    static func getToken(code: String, callback: (Account?) -> ()) {
        let authString = Keys.redditClientId + ":"
        let encoded = authString.dataUsingEncoding(NSUTF8StringEncoding)!
        		.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
        Alamofire.request(.POST, RedditRequest.apiURL + "api/v1/access_token",
      			headers: ["Authorization": "Basic \(encoded)"],
      			parameters: [
                    "grant_type": "authorization_code",
                    "code": code,
                    "redirect_uri": Keys.redditRedirectUrl
            	]).responseJSON { response in
                	let json = JSON(response.result.value!)
                    if json["access_token"] != nil {
                        let newAccount = Account()
                        newAccount.accessToken = json["access_token"].string!
                        newAccount.refreshToken = json["refresh_token"].string!
                        callback(newAccount)
                    } else {
                        callback(nil)
                    }
        		}
	}
    
    static func getDetails(account: Account, callback: (Bool) -> ()) {
        RedditRequest("api/v1/me", account: account).getJson { response in
            account.username = response["name"].string!
            let realm = try! Realm()
            try! realm.write {
                realm.add(account, update: true)
            }
            loginManager.account = account
            callback(true)
        }
    }
    
    static func refreshToken(callback: () -> ()) {
        let authString = Keys.redditClientId + ":"
        let encoded = authString.dataUsingEncoding(NSUTF8StringEncoding)!
            .base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
        Alamofire.request(.POST, RedditRequest.apiURL + "api/v1/access_token",
            headers: ["Authorization": "Basic \(encoded)"],
            parameters: [
                "grant_type": "refresh_token",
                "refresh_token": loginManager.account!.refreshToken
            ]).responseJSON { response in
                let json = JSON(response.result.value!)
                if json["access_token"] != nil {
                    let realm = try! Realm()
                    try! realm.write {
                        loginManager.account!.accessToken = json["access_token"].string!
                    }
                }
                callback()
        }
    }
    
    private class RedditRequest {
        private static let apiURL = "https://api.reddit.com/"
        private static let oauthURL = "https://oauth.reddit.com/"
        private static var url: String {
            if RedditAPI.loginManager.account != nil {
                return RedditRequest.oauthURL
            } else {
                return RedditRequest.apiURL
            }
        }
        private static var headers: [String: String] {
            if let account = RedditAPI.loginManager.account {
                return ["Authorization": "bearer \(account.accessToken)"]
            }
            return [:]
        }
        
        let path: String
        let queries: [String: String]
        let headers: [String: String]
        var attemptedRefresh = false
        
        init(_ path: String, queries: [String: String] = [:],
        		account: Account? = RedditAPI.loginManager.account) {
            if account != nil {
                self.path = RedditRequest.oauthURL + path
                self.headers = ["Authorization": "bearer \(account!.accessToken)"]
            } else {
                self.path = RedditRequest.apiURL + path
                self.headers = [:]
            }
            
            self.queries = queries
        }
        
        func getJson(callback: (JSON) -> ()) {
            Alamofire.request(.GET, path, parameters: queries, headers: headers)
                .responseJSON { response in
                    if response.response?.statusCode == 401 && !self.attemptedRefresh {
                        self.attemptedRefresh = true
                        RedditAPI.refreshToken {
                            self.getJson(callback)
                        }
                    } else {
                        if let value = response.result.value {
                            callback(JSON(value))
                        } else {
                            callback(JSON([:]))
                        }
                    }
            }
        }
    }
}
