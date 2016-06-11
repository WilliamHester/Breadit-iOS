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

        swipableView.removeFromSuperview()

        let stackView = UIStackView()
        stackView.axis = .Vertical
        stackView.spacing = 4

        submissionTitle = UILabel()
        submissionTitle.fontSize = 13
        submissionTitle.numberOfLines = 0

        submissionSubreddit = UILabel()
        submissionSubreddit.fontSize = 13
        submissionSubreddit.numberOfLines = 0

        submissionAuthor = UILabel()
        submissionAuthor.fontSize = 13
        submissionAuthor.numberOfLines = 0

        stackView.addArrangedSubview(submissionTitle)
        stackView.addArrangedSubview(swipableView)

        contentView.addSubview(stackView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
