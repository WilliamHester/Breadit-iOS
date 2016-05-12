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
    var body: BodyLabel!

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.uiStackView { v in
            v.translatesAutoresizingMaskIntoConstraints = false
            v.axis = .Vertical
            v.spacing = 4

            self.author = v.uiLabel { v in
                v.fontSize = 10
            }
            
            self.body = BodyLabel()
            self.body.add { v in
                let label = v as? UILabel
                label?.font = UIFont.systemFontOfSize(13.0)
                label?.numberOfLines = 0
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

}
