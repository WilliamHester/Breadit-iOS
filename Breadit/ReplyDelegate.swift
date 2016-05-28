//
//  ReplyDelegate.swift
//  Breadit
//
//  Created by William Hester on 5/27/16.
//  Copyright © 2016 William Hester. All rights reserved.
//

import Foundation

protocol ReplyDelegate: class {
    func didReplyTo(name: String, withTextComment textComment: TextComment)
}
