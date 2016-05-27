//
//  CommentCell.swift
//  Breadit
//
//  Created by William Hester on 4/24/16.
//  Copyright © 2016 William Hester. All rights reserved.
//

import UIKit

class TextCommentCellView: SwipeVoteCellView {
    
    var paddingConstraint: NSLayoutConstraint!

    var author: UILabel!
    var flair: UILabel!
    var pointsAndTime: UILabel!
    var body: BodyLabel!
    private var inSetup = true
    
    override var voteStatus: VoteStatus {
        didSet {
            guard !inSetup else {
                return
            }
            comment.voteStatus = voteStatus
            pointsAndTime.text = "\(comment.score) • \(shortTimeFromNow(comment))"
            RedditAPI.vote(comment.name, voteStatus: voteStatus)
        }
    }
    
    var comment: TextComment! {
        didSet {
            updateContent()
        }
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.clearColor()
        selectedBackgroundView = uiView { v in
            v.backgroundColor = Colors.secondaryColor
        }

        swipableContent.uiStackView { v in
            v.translatesAutoresizingMaskIntoConstraints = false
            v.axis = .Vertical
            v.spacing = 4
            
            v.uiStackView { v in
                v.axis = .Horizontal
                v.spacing = 4.0
                self.author = v.uiLabel { v in
                    v.fontSize = 10
                    v.textColor = Colors.infoColor
                    v.setContentCompressionResistancePriority(249, forAxis: .Horizontal)
                    v.setContentHuggingPriority(251, forAxis: .Horizontal)
                }
                self.flair = v.uiLabel { v in
                    v.fontSize = 10
                    v.textColor = Colors.secondaryTextColor
                    v.setContentCompressionResistancePriority(750, forAxis: .Horizontal)
                    v.setContentHuggingPriority(251, forAxis: .Horizontal)
                }
                self.pointsAndTime = v.uiLabel { v in
                    v.fontSize = 10
                    v.textColor = Colors.secondaryTextColor
                    v.textAlignment = .Right
                    v.setContentCompressionResistancePriority(752, forAxis: .Horizontal)
                    v.setContentHuggingPriority(250, forAxis: .Horizontal)
                }
            }
            
            self.body = BodyLabel()
            self.body.add { v in
                let label = v as? UILabel
                label?.font = UIFont.systemFontOfSize(13.0)
                label?.numberOfLines = 0
                label?.textColor = Colors.textColor
            }
            v.addChild(self.body)
        }.constrain { v in
            self.paddingConstraint = v.leftAnchor.constraintEqualToAnchor(self.swipableContent.leftAnchor, constant: 4)
            self.paddingConstraint.active = true
            v.rightAnchor.constraintEqualToAnchor(self.swipableContent.rightAnchor, constant: -4).active = true
            self.swipableContent.topAnchor.constraintEqualToAnchor(v.topAnchor, constant: -4).active = true
            self.swipableContent.bottomAnchor.constraintEqualToAnchor(v.bottomAnchor, constant: 4).active = true
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        flair.text = ""
    }
    
    func updateContent() {
        inSetup = true
        paddingConstraint.constant = CGFloat(comment.level * 8 + 8)
        author.text = comment.author
        let parsedText = HTMLParser(
            escapedHtml: comment.body_html,
            font: body.font!
        )
        body.attributedText = parsedText.attributedString
        
        pointsAndTime.text = "\(comment.score) • \(shortTimeFromNow(comment))"
        
        if let flairText = comment.author_flair_text {
            hidden = false
            flair.text = flairText
        } else {
            flair.hidden = true
        }
        
        if comment.hidden {
            hide()
        }
        
        voteStatus = comment.voteStatus
        
        inSetup = false
    }

    private func shortTimeFromNow(textComment: TextComment) -> String {
        let currentTime = Int(NSDate().timeIntervalSince1970)
        let postTime = textComment.created_utc
        let difference = max(currentTime - postTime, 0)
        var time: String
        if (difference / 31536000 > 0) {
            time = "\(difference / 31536000)y"
        } else if (difference / 2592000 > 0) {
            time = "\(difference / 2592000)mo"
        } else if (difference / 604800 > 0) {
            time = "\(difference / 604800)w"
        } else if (difference / 86400 > 0) {
            time = "\(difference / 86400)d"
        } else if (difference / 3600 > 0) {
            time = "\(difference / 3600)h"
        } else if (difference / 60 > 0) {
            time = "\(difference / 60)m"
        } else {
            time = "\(difference)s"
        }
        return time
    }
    
    func hide() {
        body.attributedText = NSMutableAttributedString(string: "Comment hidden",
        		attributes: [
                    NSForegroundColorAttributeName: Colors.secondaryTextColor,
            	])
    }

}
