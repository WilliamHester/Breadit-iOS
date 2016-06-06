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
    var points: UILabel!
    var body: BodyLabel!
    
    var comment: TextComment! {
        didSet {
            votable = comment
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
                    v.setContentCompressionResistancePriority(752, forAxis: .Horizontal)
                    v.setContentHuggingPriority(251, forAxis: .Horizontal)
                }
                self.flair = v.uiLabel { v in
                    v.fontSize = 10
                    v.textColor = Colors.secondaryTextColor
                    v.setContentCompressionResistancePriority(750, forAxis: .Horizontal)
                    v.setContentHuggingPriority(251, forAxis: .Horizontal)
                }
                self.points = v.uiLabel { v in
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
}
