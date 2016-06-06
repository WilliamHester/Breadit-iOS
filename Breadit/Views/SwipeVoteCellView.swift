//
//  SwipeVoteCellView.swift
//  Breadit
//
//  Created by William Hester on 5/26/16.
//  Copyright © 2016 William Hester. All rights reserved.
//

import UIKit

class SwipeVoteCellView: UITableViewCell {

    weak var delegate: ContentDelegate?
    var votable: Votable!

    var left: UIView!
    var right: UIView!
    var back: UIView!
    var swipableContent: UIView!
    var contentLeftConstraint: NSLayoutConstraint!
    var contentRightConstraint: NSLayoutConstraint!
    var panStartPoint = CGPoint.zero
    var canSwipe = false

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        left = UIView()
        right = UIView()
        back = UIView()
        swipableContent = UIView()
        
        contentView.addSubview(back)
        contentView.addSubview(left)
        contentView.addSubview(right)
        contentView.addSubview(swipableContent)
        
        left.backgroundColor = Colors.backgroundColor
        right.backgroundColor = Colors.backgroundColor
        back.backgroundColor = Colors.backgroundColor
        swipableContent.backgroundColor = Colors.backgroundColor
        
        left.translatesAutoresizingMaskIntoConstraints = false
        right.translatesAutoresizingMaskIntoConstraints = false
        back.translatesAutoresizingMaskIntoConstraints = false
        swipableContent.translatesAutoresizingMaskIntoConstraints = false
        
        left.widthAnchor.constraintEqualToConstant(2).active = true
        left.leftAnchor.constraintEqualToAnchor(contentView.leftAnchor).active = true
        left.topAnchor.constraintEqualToAnchor(contentView.topAnchor).active = true
        left.bottomAnchor.constraintEqualToAnchor(contentView.bottomAnchor).active = true
        
        right.widthAnchor.constraintEqualToConstant(2).active = true
        right.rightAnchor.constraintEqualToAnchor(contentView.rightAnchor).active = true
        right.topAnchor.constraintEqualToAnchor(contentView.topAnchor).active = true
        right.bottomAnchor.constraintEqualToAnchor(contentView.bottomAnchor).active = true
        
        back.leftAnchor.constraintEqualToAnchor(contentView.leftAnchor).active = true
        back.rightAnchor.constraintEqualToAnchor(contentView.rightAnchor).active = true
        back.topAnchor.constraintEqualToAnchor(swipableContent.topAnchor).active = true
        back.bottomAnchor.constraintEqualToAnchor(swipableContent.bottomAnchor).active = true
        
        swipableContent.heightAnchor.constraintEqualToAnchor(contentView.heightAnchor).active = true
        swipableContent.topAnchor.constraintEqualToAnchor(contentView.topAnchor).active = true
        
        contentLeftConstraint = swipableContent.leftAnchor.constraintEqualToAnchor(contentView.leftAnchor, constant: 2)
        contentRightConstraint = swipableContent.rightAnchor.constraintEqualToAnchor(contentView.rightAnchor, constant: -2)
        contentLeftConstraint.active = true
        contentRightConstraint.active = true
        
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(SwipeVoteCellView.didPan(_:)))
        gestureRecognizer.delegate = self
        gestureRecognizer.delaysTouchesBegan = true
        swipableContent.addGestureRecognizer(gestureRecognizer)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let panRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
            let translation = panRecognizer.translationInView(superview)
            return canSwipe && gestureRecognizer.locationInView(superview).x > 40 &&
                	abs(translation.x) > abs(translation.y) * 2
        }
        return super.gestureRecognizerShouldBegin(gestureRecognizer)
    }

    func didPan(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .Began:
            panStartPoint = recognizer.translationInView(swipableContent)
        case .Changed:
            let currentPoint = recognizer.translationInView(swipableContent)
            let deltaX = currentPoint.x - self.panStartPoint.x;
            contentLeftConstraint.constant = deltaX + 2
            contentRightConstraint.constant = deltaX - 2
            
            if deltaX == 0 {
                back.backgroundColor = UIColor.clearColor()
            } else if deltaX > 0 {
                left.backgroundColor = upvoteColor
                back.backgroundColor = upvoteColor
            } else {
                right.backgroundColor = downvoteColor
                back.backgroundColor = downvoteColor
            }
            
        case .Ended:
            let currentPoint = recognizer.translationInView(swipableContent)
            finishPan(currentPoint)
        case .Cancelled:
            break
        default:
            break
        }
    }

    private func finishPan(finishPoint: CGPoint) {
        contentLeftConstraint.constant = 2
        contentRightConstraint.constant = -2

        let deltaX = finishPoint.x - self.panStartPoint.x;
        if deltaX > 50 {
			delegate?.vote(.Right, forVotable: votable, inView: self)
        } else if deltaX < -50 {
            delegate?.vote(.Left, forVotable: votable, inView: self)
        } else {
            delegate?.vote(.None, forVotable: votable, inView: self)
        }
        UIView.animateWithDuration(0.2) {
            self.contentView.layoutIfNeeded()
        }
    }
}
