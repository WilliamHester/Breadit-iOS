//
// Created by William Hester on 6/8/16.
// Copyright (c) 2016 William Hester. All rights reserved.
//

import Foundation

protocol ListingStore: class {
    var display: String { get }
    var content: [Votable] { get }

    func loadContent(onLoad: (Int, Int) -> ())
    func refreshContent(onLoad: (Bool) -> ())
}