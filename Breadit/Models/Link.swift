//
//  Link.swift
//  Breadit
//
//  Created by William Hester on 5/10/16.
//  Copyright © 2016 William Hester. All rights reserved.
//

import Foundation

class Link {
    let url: String
    var previewUrl: String?
    var id: String?
    var linkType: LinkType = .Normal
    
    enum LinkType {
        case Normal
        case YouTube
        case Reddit(RedditType)
        case Image(ImageType)
        enum ImageType {
            case Normal
            case ImgurImage
            case ImgurAlbum
            case ImgurGallery
            case Gfycat
            case DirectGfy
            case Gif
        }
        enum RedditType {
            case Submission
            case Subreddit
            case User
            case RedditLive
            case Messages
            case Compose
        }
    }
    
    init(link: String) {
        self.url = link
        
        if self.url.hasPrefix("/") {
            if self.url[1] == "u" {
                id = self.url.substringFromIndex(url.startIndex.advancedBy(3))
                linkType = .Reddit(.User)
            } else if self.url[1] == "r" {
                self.id = self.url.substringFromIndex(url.startIndex.advancedBy(3))
                linkType = .Reddit(.Subreddit)
            }
        } else {
            let url = NSURL(string: link)!
            guard let domain = url.host else {
                return
            }
            if domain.contains("reddit.com") {
                generateRedditDetails()
            } else if domain.contains("imgur") {
                generateImgurDetails()
            } else if domain.contains("youtube.com") || domain.contains("youtu.be") {
                generateYouTubeDetails(url)
            }
        }
    }
    
    private func generateImgurDetails() {
        if url.rangeOfString("imgur.com/") != nil {
            let lastSlash = url.lastIndexOf("/")!

            if let dot = url.lastIndexOf(".") where dot > lastSlash {
                id = url.substringWithRange(lastSlash.successor()..<dot)
            } else {
                id = url.substringFromIndex(lastSlash.successor())
            }

            switch url.characters[lastSlash.predecessor()] {
            case "m": // imgur.com/.*
                linkType = .Image(.ImgurImage)
                previewUrl = url + ".png"
            case "a": // imgur.com/a/.*
                linkType = .Image(.ImgurAlbum)
            case "y": // imgur.com/gallery/.*
                linkType = .Image(.ImgurGallery)
            default:
                break
            }
        }
    }
    
    private func generateYouTubeDetails(url: NSURL) {
        linkType = .YouTube
        
        if let id = url.queries["v"] {
            self.id = id
        } else if url.host == "youtu.be" {
            let index = self.url.indexOf("youtu.be/")
            self.id = self.url.substring((index?.advancedBy(9))!, length: 11)
        }
    }
    
    private func generateRedditDetails() {
        linkType = .Reddit(.Subreddit)
    }
}
