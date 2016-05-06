//
//  HTMLParser.swift
//  Breadit
//
//  Created by William Hester on 5/1/16.
//  Copyright © 2016 William Hester. All rights reserved.
//

import UIKit
import Kanna
import SwiftString

class HTMLParser {
    
    private var attributedString: NSAttributedString
    
    init(escapedHtml html: String) {
        self.attributedString = HTMLParser.parseHtml(html)
    }
    
    private static func parseHtml(text: String) -> NSAttributedString {
        if let html = Kanna.HTML(html: text.decodeHTML(), encoding: NSUTF8StringEncoding) {
            generateString(html.body!, attributedString: NSMutableAttributedString())
        }
        return NSAttributedString()
    }
    
    private static func generateString(node: XMLElement, attributedString: NSMutableAttributedString) ->
        	NSMutableAttributedString {
        if node.tagName == nil {
            attributedString.appendAttributedString(NSAttributedString(string: node.text!))
        }
        return NSMutableAttributedString()
    }
    
    private func insertNewLine(node: XMLElement, attributedString: NSMutableAttributedString) {
        
    }
}
