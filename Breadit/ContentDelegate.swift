//
// Created by William Hester on 6/5/16.
// Copyright (c) 2016 William Hester. All rights reserved.
//

import Foundation

protocol ContentDelegate: class {
    func vote(status: SwipeVoteType, forVotable votable: Votable, inView view: SwipeVoteCellView)
    func contentTapped(link: Link)
}
