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

class SubmissionImageCellView: SubmissionCellView {
    
    private static let previewHeight: CGFloat = 150
    
    var contentImage: UIImageView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        stackView.add { v in
            self.contentImage = v.uiImageView { v in
            	v.contentMode = .ScaleAspectFill
                v.clipsToBounds = true
            }.constrain { v in
                v.leftAnchor.constraintEqualToAnchor(self.stackView.leftAnchor).active = true
                v.rightAnchor.constraintEqualToAnchor(self.stackView.rightAnchor).active = true
                v.heightAnchor.constraintEqualToConstant(SubmissionImageCellView.previewHeight).active = true
            } as! UIImageView
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        contentImage?.image = nil
    }
    
    override func setSubmission(submission: Submission) {
        super.setSubmission(submission)
        
        Alamofire.request(.GET, submission.getPreviewImage()!).responseImage { response in
            self.contentImage.image = response.result.value
        }
    }

}
