//
// Created by William Hester on 6/10/16.
// Copyright (c) 2016 William Hester. All rights reserved.
//

import UIKit

class SubmissionCommentCellView: TextCommentCellView {

    var submissionTitle: UILabel!
    var submissionSubreddit: UILabel!
    var submissionAuthor: UILabel!

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        submissionTitle = UILabel()
        submissionTitle.fontSize = 13
        submissionTitle.textColor = Colors.textColor
        submissionTitle.numberOfLines = 0
        submissionTitle.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(submissionTitle)

        contentTopAnchor.active = false

        submissionTitle.leftAnchor.constraintEqualToAnchor(contentView.leftAnchor, constant: 8).active = true
        submissionTitle.rightAnchor.constraintEqualToAnchor(contentView.rightAnchor, constant: -8).active = true

        contentView.topAnchor.constraintEqualToAnchor(submissionTitle.topAnchor, constant: -8).active = true
        swipableView.topAnchor.constraintEqualToAnchor(submissionTitle.bottomAnchor, constant: 4).active = true
        contentView.bottomAnchor.constraintEqualToAnchor(swipableView.bottomAnchor).active = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
