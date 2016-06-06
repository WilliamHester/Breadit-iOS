//
//  SubmissionImageCell.swift
//  Breadit
//
//  Created by William Hester on 5/15/16.
//  Copyright © 2016 William Hester. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class SubmissionSelfPostCellView: SubmissionCellView {
    
    private static let previewHeight: CGFloat = 150
    
    var contentBody: BodyLabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        stackView.add { v in
            self.contentBody = BodyLabel()
            self.contentBody.add { v in
                let label = v as? UILabel
                label?.font = UIFont.systemFontOfSize(13.0)
                label?.numberOfLines = 0
                label?.textColor = Colors.textColor
            }
            v.addChild(self.contentBody)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
