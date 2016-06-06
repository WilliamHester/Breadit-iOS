//
// Created by William Hester on 6/5/16.
// Copyright (c) 2016 William Hester. All rights reserved.
//

import Foundation

protocol VotableDelegate: class {
    func vote(status: VoteStatus, forVotable votable: Votable)
}
