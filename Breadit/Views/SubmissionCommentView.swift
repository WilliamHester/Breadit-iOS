//
// Created by William Hester on 6/10/16.
// Copyright (c) 2016 William Hester. All rights reserved.
//

import UIKit

class SubmissionCommentCellView: TextCommentCellView {

    var submissionTitle: UILabel!
    var submissionSubreddit: UILabel!
    var submissionAuthor: UILabel!

    private var stackView: UIStackView!

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        stackView = UIStackView()
        stackView.axis = .Vertical
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false

        submissionTitle = UILabel()
        submissionTitle.fontSize = 13
        submissionTitle.textColor = Colors.textColor
        submissionTitle.numberOfLines = 0

        submissionSubreddit = UILabel()
        submissionSubreddit.fontSize = 13
        submissionSubreddit.textColor = Colors.textColor
        submissionSubreddit.numberOfLines = 0

        submissionAuthor = UILabel()
        submissionAuthor.fontSize = 13
        submissionAuthor.textColor = Colors.textColor
        submissionAuthor.numberOfLines = 0

        stackView.addArrangedSubview(submissionTitle)
        stackView.addArrangedSubview(submissionSubreddit)
        stackView.addArrangedSubview(submissionAuthor)

        contentView.addSubview(stackView)

        contentTopAnchor.active = false

        stackView.leftAnchor.constraintEqualToAnchor(contentView.leftAnchor, constant: 8).active = true
        stackView.rightAnchor.constraintEqualToAnchor(contentView.rightAnchor, constant: 8).active = true

        contentView.topAnchor.constraintEqualToAnchor(stackView.topAnchor, constant: -8).active = true
        swipableView.topAnchor.constraintEqualToAnchor(stackView.bottomAnchor, constant: 4).active = true
        contentView.bottomAnchor.constraintEqualToAnchor(swipableView.bottomAnchor).active = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
