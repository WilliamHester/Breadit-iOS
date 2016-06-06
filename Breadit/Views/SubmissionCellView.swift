//
// Created by William Hester on 4/23/16.
// Copyright (c) 2016 William Hester. All rights reserved.
//

import Foundation
import UIKit
import NSDate_TimeAgo
import SwiftString

class SubmissionCellView: SwipeVoteCellView {

    var points: UILabel!
    var nsfw: UILabel!
    var title: UILabel!
    var authorAndSubreddit: UILabel!
    var comments: UILabel!
    var stackView: UIStackView!
    var submission: Submission! {
        didSet {
            votable = submission
        }
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.clearColor()
        selectedBackgroundView = uiView { v in
            v.backgroundColor = UIColor.darkGrayColor()
        }

        swipableContent.uiStackView { v in
            self.stackView = v
            v.translatesAutoresizingMaskIntoConstraints = false
            v.axis = .Vertical
            v.spacing = 4
            
            v.uiStackView { v in
                v.distribution = .FillEqually
                v.axis = .Horizontal
                
            	self.points = v.uiLabel { v in
                	v.fontSize = 12
                	v.textColor = Colors.secondaryTextColor
            	}
                
                self.nsfw = v.uiLabel { v in
                    v.fontSize = 12
                    v.textColor = UIColor(rgb: 0xBF3F3F)
                    v.text = "NSFW"
                    v.textAlignment = .Right
                }
            }
            
            self.title = v.uiLabel { v in
                v.numberOfLines = 0
                v.textColor = Colors.textColor
                v.font = UIFont(name: "PingFangHK-Medium", size: 14)
            }
                
            self.authorAndSubreddit = v.uiLabel { v in
                v.fontSize = 10
                v.textColor = Colors.infoColor
            }

            self.comments = v.uiLabel { v in
                v.fontSize = 10
                v.textColor = Colors.secondaryTextColor
            }
        }.constrain { v in
            v.leftAnchor.constraintEqualToAnchor(self.swipableContent.leftAnchor, constant: 8).active = true
            v.rightAnchor.constraintEqualToAnchor(self.swipableContent.rightAnchor, constant: -8).active = true
            self.swipableContent.topAnchor.constraintEqualToAnchor(v.topAnchor, constant: -8).active = true
            self.swipableContent.bottomAnchor.constraintEqualToAnchor(v.bottomAnchor, constant: 8).active = true
        }
    }
    
    override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        return gestureRecognizer is UITapGestureRecognizer || super.gestureRecognizerShouldBegin(gestureRecognizer)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
