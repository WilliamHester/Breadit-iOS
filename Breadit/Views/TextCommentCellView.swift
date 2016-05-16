//
//  CommentCell.swift
//  Breadit
//
//  Created by William Hester on 4/24/16.
//  Copyright © 2016 William Hester. All rights reserved.
//

import UIKit

class TextCommentCellView: CommentCellView {

    var author: UILabel!
    var flair: UILabel!
    var pointsAndTime: UILabel!
    var body: BodyLabel!

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.uiStackView { v in
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
            self.paddingConstraint = v.leftAnchor.constraintEqualToAnchor(self.contentView.leftAnchor, constant: 4)
            self.paddingConstraint.active = true
            v.rightAnchor.constraintEqualToAnchor(self.contentView.rightAnchor, constant: -4).active = true
            self.contentView.topAnchor.constraintEqualToAnchor(v.topAnchor, constant: -4).active = true
            self.contentView.bottomAnchor.constraintEqualToAnchor(v.bottomAnchor, constant: 4).active = true
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        flair.text = ""
    }
    
    func hide() {
        body.attributedText = NSMutableAttributedString(string: "Comment hidden",
        		attributes: [
                    NSForegroundColorAttributeName: Colors.secondaryTextColor,
            	])
    }

}
