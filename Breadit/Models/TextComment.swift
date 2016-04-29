//
//  TextComment.swift
//  Breadit
//
//  Created by William Hester on 4/28/16.
//  Copyright © 2016 William Hester. All rights reserved.
//

import Foundation
import SwiftyJSON

class TextComment: Comment {
    
    var level: Int

    let subreddit_id: String
    let id: String
    let author: String
    let parent_id: String
    let body: String
    let body_html: String
    let name: String
    let author_flair_text: String?
    let distinguished: String?
    let gilded: Int
    let score: Int
    let created: Int
    let created_utc: Int
    let ups: Int
    let edited: Int?
    let saved: Bool
    let archived: Bool
    let score_hidden: Bool
    let stickied: Bool
    let likes: Bool?
    var replies: [Comment]? = [Comment]()

    init(json: JSON, level: Int) {
        self.subreddit_id = json["subreddit_id"].string!
        self.id = json["id"].string!
        self.author = json["author"].string!
        self.parent_id = json["parent_id"].string!
        self.body = json["body"].string!
        self.body_html = json["body_html"].string!
        self.name = json["name"].string!
        self.author_flair_text = json["author_flair_text"].string
        self.distinguished = json["distinguished"].string
        self.gilded = json["gilded"].int!
        self.score = json["score"].int!
        self.created = json["created"].int!
        self.created_utc = json["created_utc"].int!
        self.ups = json["ups"].int!
        self.edited = json["edited"].int
        self.saved = json["saved"].bool!
        self.archived = json["archived"].bool!
        self.score_hidden = json["score_hidden"].bool!
        self.stickied = json["stickied"].bool!
        self.likes = json["likes"].bool

        self.level = level

        if json["replies"].string == nil {
            for jsonData in json["replies"]["data"]["children"].array! {
                if jsonData["kind"] == "more" {
                    replies?.append(MoreComment(json: jsonData["data"], level: level + 1))
                } else {
                    replies?.append(TextComment(json: jsonData["data"], level: level + 1))
                }
            }
        }
    }
}
