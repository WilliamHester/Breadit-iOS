//
//  SubmissionImageCell.swift
//  Breadit
//
//  Created by William Hester on 4/23/16.
//  Copyright © 2016 William Hester. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class SubmissionLinkCellView: SubmissionCellView {
    
    private static let previewHeight: CGFloat = 150

    var linkContent: UIView!
    var thumbnailImage: UIImageView!
    var linkDescription: UILabel!
    var thumbnailWidth: NSLayoutConstraint!
    var request: Request?

    override var submission: Submission! {
        didSet {
            request = Alamofire.request(.GET, submission.thumbnail).responseImage { response in
                if response.result.isSuccess {
                    self.thumbnailImage.image = response.result.value
                } else {
                    self.thumbnailWidth.constant = 0
                }
            }
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        linkContent = UIView()
        thumbnailImage = UIImageView()
        linkDescription = UILabel()

        linkContent.backgroundColor = Colors.secondaryColor
        linkContent.layer.borderColor = Colors.borderColor.CGColor
        linkContent.layer.borderWidth = 1.0
        linkContent.layer.cornerRadius = 4.0
        linkContent.clipsToBounds = true

        linkDescription.textColor = Colors.secondaryTextColor

        stackView.addArrangedSubview(linkContent)
        linkContent.addSubview(thumbnailImage)
        linkContent.addSubview(linkDescription)

        linkContent.translatesAutoresizingMaskIntoConstraints = false
        thumbnailImage.translatesAutoresizingMaskIntoConstraints = false
        linkDescription.translatesAutoresizingMaskIntoConstraints = false

        thumbnailImage.heightAnchor.constraintEqualToConstant(60).active = true
        thumbnailWidth = thumbnailImage.widthAnchor.constraintEqualToConstant(60)
        thumbnailWidth.active = true
        thumbnailImage.topAnchor.constraintEqualToAnchor(linkContent.topAnchor).active = true
        thumbnailImage.leftAnchor.constraintEqualToAnchor(linkContent.leftAnchor).active = true

        linkDescription.centerYAnchor.constraintEqualToAnchor(linkContent.centerYAnchor).active = true
        linkDescription.leftAnchor.constraintEqualToAnchor(thumbnailImage.rightAnchor, constant: 8).active = true
        linkDescription.rightAnchor.constraintEqualToAnchor(linkContent.rightAnchor).active = true

        linkContent.heightAnchor.constraintEqualToAnchor(thumbnailImage.heightAnchor).active = true
        
        let tapDetector = UITapGestureRecognizer(target: self, action: #selector(contentTapped(_:)))
        tapDetector.delegate = self
        tapDetector.cancelsTouchesInView = true
        linkContent.userInteractionEnabled = true
        linkContent.addGestureRecognizer(tapDetector)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        thumbnailImage?.image = nil
        thumbnailWidth.constant = 60
        if let request = request {
            request.cancel()
            self.request = nil
        }
    }
    
    func contentTapped(gestureDetector: UITapGestureRecognizer) {
        delegate?.contentTapped(submission.link!)
    }
}
