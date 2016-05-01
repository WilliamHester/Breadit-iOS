//
//  MoreCommentCellView.swift
//  Breadit
//
//  Created by William Hester on 4/30/16.
//  Copyright © 2016 William Hester. All rights reserved.
//

import UIKit

class MoreCommentCellView : CommentCellView {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.uiLabel { v in
            v.text = "Load more comments..."
            v.fontSize = 12
        }.constrain { v in
            self.paddingConstraint = v.leftAnchor.constraintEqualToAnchor(self.contentView.leftAnchor)
            self.paddingConstraint.active = true
            v.rightAnchor.constraintEqualToAnchor(self.contentView.rightAnchor)
            self.contentView.topAnchor.constraintEqualToAnchor(v.topAnchor)
            self.contentView.bottomAnchor.constraintEqualToAnchor(v.bottomAnchor)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
