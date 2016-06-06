//
// Created by William Hester on 6/5/16.
// Copyright (c) 2016 William Hester. All rights reserved.
//

import Foundation

protocol Votable: class {
    var name: String { get }
    var voteStatus: VoteStatus { get set }
}
