//
//  String.swift
//  Breadit
//
//  Created by William Hester on 5/24/16.
//  Copyright © 2016 William Hester. All rights reserved.
//

import Foundation

extension String {

    func indexOf(character: Character) -> Index? {
        for (num, char) in self.characters.enumerate() {
            if char == character {
                return self.startIndex.advancedBy(num)
            }
        }
        return nil
    }

    func lastIndexOf(character: Character) -> Index? {
        for (num, char) in self.characters.reverse().enumerate() {
            if char == character {
                return self.startIndex.advancedBy(self.length - num - 1)
            }
        }
        return nil
    }

}
