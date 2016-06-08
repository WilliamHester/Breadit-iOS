//
// Created by William Hester on 6/7/16.
// Copyright (c) 2016 William Hester. All rights reserved.
//

import UIKit

class SwipeVoteView: UIView, UIGestureRecognizerDelegate {

    weak var delegate: ContentDelegate?
    var votable: Votable!

    var left: UIView!
    var right: UIView!
    var back: UIView!
    var content: UIView!
    var contentLeftConstraint: NSLayoutConstraint!
    var contentRightConstraint: NSLayoutConstraint!
    var panStartPoint = CGPoint.zero
    var canSwipe = false

    init() {
        super.init(frame: CGRect.zero)
        left = UIView()
        right = UIView()
        back = UIView()
        content = UIView()

        addSubview(back)
        addSubview(left)
        addSubview(right)
        addSubview(content)

        left.backgroundColor = Colors.backgroundColor
        right.backgroundColor = Colors.backgroundColor
        back.backgroundColor = Colors.backgroundColor
        content.backgroundColor = Colors.backgroundColor

        translatesAutoresizingMaskIntoConstraints = false

        left.translatesAutoresizingMaskIntoConstraints = false
        right.translatesAutoresizingMaskIntoConstraints = false
        back.translatesAutoresizingMaskIntoConstraints = false
        content.translatesAutoresizingMaskIntoConstraints = false

        left.widthAnchor.constraintEqualToConstant(2).active = true
        left.leftAnchor.constraintEqualToAnchor(leftAnchor).active = true
        left.topAnchor.constraintEqualToAnchor(topAnchor).active = true
        left.bottomAnchor.constraintEqualToAnchor(bottomAnchor).active = true

        right.widthAnchor.constraintEqualToConstant(2).active = true
        right.rightAnchor.constraintEqualToAnchor(rightAnchor).active = true
        right.topAnchor.constraintEqualToAnchor(topAnchor).active = true
        right.bottomAnchor.constraintEqualToAnchor(bottomAnchor).active = true

        back.leftAnchor.constraintEqualToAnchor(leftAnchor).active = true
        back.rightAnchor.constraintEqualToAnchor(rightAnchor).active = true
        back.topAnchor.constraintEqualToAnchor(content.topAnchor).active = true
        back.bottomAnchor.constraintEqualToAnchor(content.bottomAnchor).active = true

        content.heightAnchor.constraintEqualToAnchor(heightAnchor).active = true
        content.topAnchor.constraintEqualToAnchor(topAnchor).active = true

        contentLeftConstraint = content.leftAnchor.constraintEqualToAnchor(leftAnchor, constant: 2)
        contentRightConstraint = content.rightAnchor.constraintEqualToAnchor(rightAnchor, constant: -2)
        contentLeftConstraint.active = true
        contentRightConstraint.active = true

        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
        gestureRecognizer.delegate = self
        gestureRecognizer.delaysTouchesBegan = true
        addGestureRecognizer(gestureRecognizer)

        userInteractionEnabled = true
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
            panStartPoint = recognizer.translationInView(content)
        case .Changed:
            let currentPoint = recognizer.translationInView(content)
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
            let currentPoint = recognizer.translationInView(content)
            finishPan(currentPoint)
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
            self.layoutIfNeeded()
        }
    }

}
