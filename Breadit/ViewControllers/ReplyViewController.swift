//
// Created by William Hester on 5/27/16.
// Copyright (c) 2016 William Hester. All rights reserved.
//

import UIKit

class ReplyViewController: UIViewController, UITextViewDelegate {

    var userInput: UITextView!
    var username: String!
    var name: String!
    var level = -1
    var delegate: ReplyDelegate!
    var activityIndicator: UIActivityIndicatorView!

    override func loadView() {
        userInput = UITextView()
        view = userInput
        view.backgroundColor = Colors.backgroundColor
		userInput.delegate = self
        userInput.textColor = Colors.textColor
        userInput.editable = true
        setHint()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 40.0, 40.0))
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        activityIndicator.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor).active = true
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = .WhiteLarge

        title = "Reply"

        navigationItem.setRightBarButtonItem(UIBarButtonItem(barButtonSystemItem: .Reply, target: self,
                action: #selector(ReplyViewController.reply(_:))), animated: false)
    }
    
    func setSubmission(submission: Submission) {
        name = submission.name
        username = submission.author
    }
    
    func setComment(comment: TextComment) {
        name = comment.name
        username = comment.author
        level = comment.level
    }

    func reply(obj: AnyObject) {
        userInput.editable = false

        activityIndicator.startAnimating()

        RedditAPI.reply(name, text: userInput.text, parentLevel: level) { comment in
            self.activityIndicator.stopAnimating()
            if let comment = comment {
                self.delegate.didReplyTo(self.name, withTextComment: comment)
                self.dismissViewControllerAnimated(true, completion: nil)
            } else {
                print("failed")
            }
        }
    }
    
    func done(obj: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    func textViewShouldBeginEditing(textField: UITextView) -> Bool {
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: #selector(ReplyViewController.keyboardDidShow(_:)),
                name: UIKeyboardDidShowNotification, object: nil)
        return true
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if let text = userInput.attributedText where text.length > 0 {
            let attributes = text.attributesAtIndex(0, effectiveRange: nil)
            if attributes[NSForegroundColorAttributeName] as? UIColor == Colors.secondaryTextColor {
                userInput.text = ""
                userInput.font = UIFont.systemFontOfSize(16)
                userInput.textColor = Colors.textColor
            }
        }
    }

    func textViewShouldEndEditing(textField: UITextView) -> Bool {
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: #selector(ReplyViewController.keyboardDidHide(_:)),
                name: UIKeyboardDidHideNotification, object: nil)
        return true
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if userInput.text.length == 0 {
            setHint()
        }
    }

    func keyboardDidShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            self.view.frame.size.height -= keyboardSize.height
        }
    }

    func keyboardDidHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            self.view.frame.size.height += keyboardSize.height
        }
    }

    private func setHint() {
        userInput.attributedText = NSAttributedString(string: "Reply to /u/\(username)",
                attributes: [
                        NSForegroundColorAttributeName: Colors.secondaryTextColor,
                        NSFontAttributeName: UIFont.systemFontOfSize(16)
                ])
    }
}
