//
//  SubmissionView.swift
//  Breadit
//
//  Created by William Hester on 4/30/16.
//  Copyright © 2016 William Hester. All rights reserved.
//

import UIKit

class SubmissionView: UIView {
    
    var subreddit: UILabel!
    var title: UILabel!
    var author: UILabel!
    var points: UILabel!
    var comments: UILabel!
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 300, height: 150))

        uiStackView { v in
            v.axis = .Vertical
            v.spacing = 4

            self.subreddit = v.uiLabel { v in
                v.font = v.font.fontWithSize(10)
                v.textColor = Colors.textColor
            }

            self.title = v.uiLabel { v in
                v.numberOfLines = 0
                v.textColor = Colors.textColor
            }

            v.uiStackView { v in
                v.axis = .Horizontal
                v.distribution = .FillEqually

                self.author = v.uiLabel { v in
                    v.font = v.font.fontWithSize(10)
                    v.textColor = Colors.textColor
                }

                self.points = v.uiLabel { v in
                    v.font = v.font.fontWithSize(10)
                    v.textAlignment = .Right
                    v.textColor = Colors.textColor
                }
            }

            self.comments = v.uiLabel { v in
                v.font = v.font.fontWithSize(10)
                v.textColor = Colors.textColor
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
