//
//  NSURL.swift
//  Breadit
//
//  Created by William Hester on 5/12/16.
//  Copyright © 2016 William Hester. All rights reserved.
//

import UIKit

extension NSURL {
    var queries: [String: String] {
        var dict = [String: String]()
        if let query = query {
        	for item in query.componentsSeparatedByString("&") {
            	let keyValuePair = item.componentsSeparatedByString("=")
            	dict[keyValuePair[0]] = keyValuePair[1]
        	}
        }
        return dict
    }
}
