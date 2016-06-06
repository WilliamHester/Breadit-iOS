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
    var request: Request?

    // TODO: Look into moving this logic to the actual ViewController
    override var submission: Submission! {
        didSet {
            request = Alamofire.request(.GET, submission.link!.previewUrl!).responseImage { response in
                self.contentImage.image = response.result.value
            }
        }
    }

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
        let tapDetector = UITapGestureRecognizer(target: self, action: #selector(contentTapped(_:)))
        tapDetector.delegate = self
        tapDetector.cancelsTouchesInView = true
        contentImage.userInteractionEnabled = true
        contentImage.addGestureRecognizer(tapDetector)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        contentImage?.image = nil
        if let request = request {
            request.cancel()
            self.request = nil
        }
    }
    
    func contentTapped(sender: UITapGestureRecognizer) {
        delegate?.contentTapped(submission.link!)
    }
}
