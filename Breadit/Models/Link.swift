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
                return
            } else if domain.contains("imgur") {
                generateImgurDetails()
                return
            } else if domain.contains("youtube.com") || domain.contains("youtu.be") {
                generateYouTubeDetails(url)
                return
            }
            if let lastComponent = url.lastPathComponent {
                if isDirectImage(lastComponent) {
                	linkType = .Image(.Normal)
                	previewUrl = self.url
                } else if lastComponent.lowercaseString.hasSuffix(".gif") {
                    linkType = .Image(.Gif)
                }
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
            // Need to ensure that the id is only length 7
            id = String(id!.utf8.prefix(7))

            switch url.characters[lastSlash.predecessor()] {
            case "m": // imgur.com/.*
                linkType = .Image(.ImgurImage)
                previewUrl = "https://imgur.com/\(id!)h.png"
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
        previewUrl = "http://img.youtube.com/vi/\(id!)/0.jpg";
    }
    
    private func generateRedditDetails() {
        if let range = url.rangeOfString("/r/") {
            let endPart = url.substringFromIndex(range.endIndex)
            if let nextSlash = endPart.indexOf("/") {
                if nextSlash == endPart.length {
                	id = endPart.substringToIndex(endPart.startIndex.advancedBy(nextSlash))
                    linkType = .Reddit(.Subreddit)
                } else {
                    id = "/r/" + endPart
                    linkType = .Reddit(.Submission)
                }
            } else {
                id = endPart
                linkType = .Reddit(.Subreddit)
            }
        } else if let range = url.rangeOfString("/live/") {
            id = url.substringFromIndex(range.endIndex)
            linkType = .Reddit(.RedditLive)
        } else if let range = url.rangeOfString("/user/") {
            id = url.substringFromIndex(range.endIndex)
            linkType = .Reddit(.User)
        } else if let range = url.rangeOfString("/u/") {
            id = url.substringFromIndex(range.endIndex)
            linkType = .Reddit(.User)
        } else if url.hasSuffix(".com/") || url.hasSuffix(".com") {
            id = ""
            linkType = .Reddit(.Subreddit)
        } else {
            linkType = .Normal
        }
    }
    
    private func isDirectImage(urlEnd: String) -> Bool {
        let urlEnd = urlEnd.lowercaseString
        return urlEnd.hasSuffix("png") || urlEnd.hasSuffix("jpg") || urlEnd.hasSuffix("jpeg") ||
            	urlEnd.hasSuffix("bmp")
    }
}
