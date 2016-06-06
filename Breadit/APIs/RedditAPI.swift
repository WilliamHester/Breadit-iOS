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
    
    static var loginManager = LoginManager.singleton
    static let realm = try! Realm()
    
    static func vote(votable: Votable) {
        let direction = String(votable.voteStatus.rawValue)
        let request = RedditRequest("api/vote/", requestType: .POST,
                params: ["id": votable.name, "dir": direction])
        request.getJson {_ in}
    }

    static func reply(name: String, text: String, parentLevel: Int = 0, callback: (TextComment?) -> ()) {
        let request = RedditRequest("api/comment", requestType: .POST,
                params: [
                        "api_type": "json",
                        "text": text,
                        "thing_id": name
                ])

        request.getJson { json in
            let commentJson = json["json"]["data"]["things"][0]["data"]
            if commentJson.dictionary != nil {
                let comment = TextComment(json: commentJson, level: parentLevel + 1)
                callback(comment)
            } else {
                callback(nil)
            }
        }
    }

    static func getSubmissions(place: String, query: String?, after: String?, callback: ([Submission]) -> ()) {
        var params: [String: String] = [:]
        if let query = query {
            params["q"] = query
        }
        if let after = after {
            params["after"] = after
        }
        let request = RedditRequest(place, params: params)
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
    
    static func getComments(permalink: String, callback: (Submission?, [Comment]) -> ()) {
        let request = RedditRequest(permalink)
        request.getJson { json in
            var submission: Submission? = nil
            let submissionData = json[0]["data"]["children"][0]["data"]
            if submissionData.dictionary != nil {
                submission = Submission(json: submissionData)
            }

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
    
    static func getMoreComments(moreComment: MoreComment, forSubmission submission: Submission, callback: ([Comment] -> ())) {
        var children = ""
        for commentId in moreComment.children {
            children += commentId
            children += ","
        }
        if children.length > 0 {
            children = children.substringToIndex(children.endIndex.predecessor())
        }
        RedditRequest("api/morechildren", params: [
                    "api_type": "json",
                    "link_id": submission.name,
                    "children": children,
                    "sort": "top"
            ]).getJson { json in
                var comments = [Comment]()
                if let array = json["json"]["data"]["things"].array {
                    for obj in array {
                        guard obj.dictionary != nil else {
                            callback([])
                            return
                        }
                        var newLevel = moreComment.level
                        for comment in comments {
                            if let parentId = obj["data"]["parent_id"].string where parentId == comment.parentId {
                                newLevel = comment.level + 1
                                break
                            }
                        }

                        if let kind = obj["kind"].string {
                            if kind == "more" {
                                comments.append(MoreComment(json: obj["data"], level: newLevel))
                            } else if kind == "t1" {
                                comments.append(TextComment(json: obj["data"], level: newLevel))
                            }
                        }
                    }
                    callback(comments)
                } else {
                    callback([])
                }
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
        
        let request = RedditRequest("subreddits/\(type)", params: ["after": after])
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
        let requestType: Alamofire.Method
        
        init(_ path: String, requestType: Alamofire.Method = .GET, params: [String: String] = [:],
                account: Account? = RedditAPI.loginManager.account) {
            if account != nil {
                self.path = RedditRequest.oauthURL + path
                self.headers = ["Authorization": "bearer \(account!.accessToken)"]
            } else {
                self.path = RedditRequest.apiURL + path
                self.headers = [:]
            }
            self.requestType = requestType
            self.queries = params
        }
        
        func getJson(callback: (JSON) -> ()) {
            Alamofire.request(requestType, path, parameters: queries, headers: headers)
                .responseJSON { response in
                    if !response.result.isSuccess {
                        print(response)
                    }
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
