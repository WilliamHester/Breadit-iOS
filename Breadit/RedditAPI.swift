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

}

private class RedditRequest {
    private static let baseURL = "https://api.reddit.com/"
    
    let path: String
    let queries: [String : String]
    
    init(_ path: String, queries: [String : String]) {
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
