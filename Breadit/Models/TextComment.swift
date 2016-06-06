//
//  TextComment.swift
//  Breadit
//
//  Created by William Hester on 4/28/16.
//  Copyright © 2016 William Hester. All rights reserved.
//

import Foundation
import SwiftyJSON

class TextComment: Comment, Votable {

    let subreddit_id: String
    let id: String
    let author: String
    let body: String
    let bodyHTML: String
    let authorFlairText: String?
    let distinguished: String?
    let gilded: Int
    var score: Int
    let created: Int
    let createdUTC: Int
    let ups: Int
    let edited: Int?
    let saved: Bool
    let archived: Bool
    let score_hidden: Bool
    let stickied: Bool
    let likes: Bool?
    var replies: [Comment]? = [Comment]()
    var voteStatus: VoteStatus {
        willSet(newStatus) {
            score -=  voteStatus.rawValue - newStatus.rawValue
        }
    }
    var hidden = false

    override init(json: JSON, level: Int) {
        self.subreddit_id = json["subreddit_id"].string!
        self.id = json["id"].string!
        self.author = json["author"].string!
        self.body = json["body"].string!
        self.bodyHTML = json["body_html"].string!
        self.authorFlairText = json["author_flair_text"].string
        self.distinguished = json["distinguished"].string
        self.gilded = json["gilded"].int!
        self.score = json["score"].int!
        self.created = json["created"].int!
        self.createdUTC = json["created_utc"].int!
        self.ups = json["ups"].int!
        self.edited = json["edited"].int
        self.saved = json["saved"].bool!
        self.archived = json["archived"].bool!
        self.score_hidden = json["score_hidden"].bool!
        self.stickied = json["stickied"].bool!
        self.likes = json["likes"].bool
        
        if let likes = likes {
            voteStatus = likes ? .Upvoted : .Downvoted
        } else {
            voteStatus = .Neutral
        }

        if json["replies"].string == nil {
            for jsonData in json["replies"]["data"]["children"].array! {
                if jsonData["kind"] == "more" {
                    replies?.append(MoreComment(json: jsonData["data"], level: level + 1))
                } else {
                    replies?.append(TextComment(json: jsonData["data"], level: level + 1))
                }
            }
        }

        super.init(json: json, level: level)
    }
}
