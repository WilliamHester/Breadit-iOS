//
// Created by William Hester on 4/23/16.
// Copyright (c) 2016 William Hester. All rights reserved.
//

import Foundation
import UIKit

class SubmissionCellView: UITableViewCell {

    var title: UILabel!
    var authorAndPoints: UILabel!
    var subreddit: UILabel!
    var relativeDate: UILabel!
    var comments: UILabel!
    var domain: UILabel!
    var stackView: UIStackView!

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.clearColor()
        selectedBackgroundView = uiView { v in
            v.backgroundColor = UIColor.darkGrayColor()
        }

        contentView.uiStackView { v in
            self.stackView = v
            v.translatesAutoresizingMaskIntoConstraints = false
            v.axis = .Vertical
            v.spacing = 4
            
            self.subreddit = v.uiLabel { v in
                v.fontSize = 10
                v.textColor = Colors.secondaryTextColor
            }
            
            self.title = v.uiLabel { v in
                v.numberOfLines = 0
                v.textColor = Colors.textColor
            }
            
            v.uiStackView { v in
                v.axis = .Horizontal
                v.distribution = .FillEqually
                
                self.authorAndPoints = v.uiLabel { v in
                    v.fontSize = 10
                    v.textColor = Colors.secondaryTextColor
                }
                
                self.relativeDate = v.uiLabel { v in
                    v.fontSize = 10
                    v.textAlignment = .Right
                    v.textColor = Colors.secondaryTextColor
                }
            }

            v.uiStackView { v in
                v.axis = .Horizontal
                v.distribution = .FillEqually
                self.comments = v.uiLabel { v in
                    v.fontSize = 10
                    v.textColor = Colors.secondaryTextColor
                }

                self.domain = v.uiLabel { v in
                    v.fontSize = 10
                    v.textAlignment = .Right
                    v.textColor = Colors.secondaryTextColor
                }
            }

        }.constrain { v in
            v.leftAnchor.constraintEqualToAnchor(self.contentView.leftAnchor, constant: 8).active = true
            v.rightAnchor.constraintEqualToAnchor(self.contentView.rightAnchor, constant: -8).active = true
            self.contentView.topAnchor.constraintEqualToAnchor(v.topAnchor, constant: -8).active = true
            self.contentView.bottomAnchor.constraintEqualToAnchor(v.bottomAnchor, constant: 8).active = true
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
