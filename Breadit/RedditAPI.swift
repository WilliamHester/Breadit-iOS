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

struct RedditAPI {

    static func getSubmissions(after: String, callback: ([Submission]) -> ()) {
        let request = RedditRequest("", queries: ["after" : after])
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
    
    static func getToken(code: String, callback: () -> ()) {
        let authString = Keys.redditClientId + ":"
        let encoded = authString.dataUsingEncoding(NSUTF8StringEncoding)!
        		.base64EncodedDataWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
        print(encoded)
        Alamofire.request(.POST, RedditRequest.baseURL + "/api/v1/access_token",
      			headers: ["Authorization": "Basic \(encoded)"],
      			parameters: [
                    "grant_type": "authorization_code",
                    "code": code,
                    "redirect_uri": Keys.redditRedirectUrl
            	]).responseJSON { response in
                	print(response)
                    callback()
        		}
	}

}

private class RedditRequest {
    private static let baseURL = "https://api.reddit.com/"
    
    let path: String
    let queries: [String : String]
    
    init(_ path: String, queries: [String : String] = [:]) {
        self.path = path
        self.queries = queries
    }

    func getJson(callback: (JSON) -> ()) {
        Alamofire.request(.GET, RedditRequest.baseURL + path, parameters: queries)
            	.responseJSON { response in
            callback(JSON(response.result.value!))
        }
    }
}
