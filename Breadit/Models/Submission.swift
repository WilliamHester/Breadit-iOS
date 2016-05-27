//
//  Submission.swift
//  Breadit
//
//  Created by William Hester on 4/23/16.
//  Copyright © 2016 William Hester. All rights reserved.
//

import Foundation
import SwiftyJSON

class Submission {

    let domain: String
    let subreddit: String
    let subredditId: String
    let id: String
    let name: String
    let author: String
    let thumbnail: String
    let permalink: String
    let url: String
    let title: String
    let postHint: String?
    var selftextHtml: String?
    var linkFlairText: String?
    var authorFlairText: String?
    var distinguished: String?
    var edited: Bool?
    let archived: Bool
    var over18: Bool
    var hidden: Bool
    var saved: Bool
    var stickied: Bool
    let isSelf: Bool
    var locked: Bool
    var hideScore: Bool
    var visited: Bool
    var gilded: Int
    var score: Int
    let created: Int
    let createdUTC: Int
    var numComments: Int
    var editedUTC: Int?
    var link: Link?
    var voteStatus: VoteStatus {
        willSet(newStatus) {
            score -=  voteStatus.rawValue - newStatus.rawValue
        }
    }

    init(json: JSON) {
        domain = json["domain"].string!
        subreddit = json["subreddit"].string!
        id = json["id"].string!
        author = json["author"].string!
        name = json["name"].string!
        thumbnail = json["thumbnail"].string!
        subredditId = json["subreddit_id"].string!
        postHint = json["post_hint"].string
        permalink = json["permalink"].string!
        url = json["url"].string!
        title = json["title"].string!
        selftextHtml = json["selftext_html"].string
        linkFlairText = json["link_flair_text"].string
        authorFlairText = json["author_flair_text"].string
        distinguished = json["distinguished"].string
        archived = json["archived"].bool!
        over18 = json["over_18"].bool!
        hidden = json["hidden"].bool!
        edited = json["edited"].bool
        saved = json["saved"].bool!
        stickied = json["stickied"].bool!
        isSelf = json["is_self"].bool!
        locked = json["locked"].bool!
        hideScore = json["hide_score"].bool!
        visited = json["visited"].bool!
        gilded = json["gilded"].int!
        score = json["score"].int!
        created = json["created"].int!
        createdUTC = json["created_utc"].int!
        numComments = json["num_comments"].int!
        editedUTC = json["edited"].int
        editedUTC = editedUTC > 0 ? editedUTC : nil

        if let likes = json["likes"].bool {
            voteStatus = likes ? .Upvoted : .Downvoted
        } else {
            voteStatus = .Neutral
        }
        
        if !isSelf {
            link = Link(link: url)
        }
    }

}
