//
//  HTMLParser.swift
//  Breadit
//
//  Created by William Hester on 5/1/16.
//  Copyright © 2016 William Hester. All rights reserved.
//

import UIKit
import Fuzi
import SwiftString

class HTMLParser {
    
    var attributedString: NSAttributedString!
    
    init(escapedHtml html: String) {
        self.attributedString = self.parseHtml(html.decodeHTML())
    }
    
    private func parseHtml(text: String) -> NSAttributedString {
        let html = try! XMLDocument(string: text, encoding: NSUTF8StringEncoding)
        let string = generateString(html.root!, attributedString: NSMutableAttributedString())
        var endCharacter = string.mutableString.length - 1
        while endCharacter > 0 {
            let char = string.mutableString.characterAtIndex(endCharacter)
            let newline = "\n"
            if Character(UnicodeScalar(char)) == newline[newline.startIndex] {
                endCharacter -= 1
            } else {
                break
            }
        }
        return string
    }
    
    private func generateString(node: XMLNode, attributedString: NSMutableAttributedString) -> NSMutableAttributedString {
        if node.type == XMLNodeType.Text {
            attributedString.appendAttributedString(NSAttributedString(string: node.stringValue))
            return attributedString
        }
        if let element = node as? XMLElement {
        	for child in element.childNodes(ofTypes: [.Element, .Text]) {
            	attributedString.appendAttributedString(generateString(child,
                    	attributedString: NSMutableAttributedString()))
            }

            if attributedString.length > 0 {
                let (name, value) = getAttributeNameFromTag(element)
                if value != nil {
                	attributedString.addAttribute(name, value: value!,
                			range: NSMakeRange(0, attributedString.length))
                }
            }
        }
        
        return attributedString
    }
    
    private func getAttributeNameFromTag(node: XMLElement) -> (String, AnyObject?) {
        guard node.tag != nil else {
            return ("", nil)
        }
        switch node.tag! {
        case "code":
            return (NSFontAttributeName, UIFont(name: "Menlo-Regular", size: 12.0))
        case "h1":
            return (NSFontAttributeName, UIFont.boldSystemFontOfSize(14.0))
        case "strong":
            return (NSFontAttributeName, UIFont.boldSystemFontOfSize(12.0))
        case "em":
            return (NSFontAttributeName, UIFont.italicSystemFontOfSize(12.0))
        case "a":
            return (NSLinkAttributeName, node.stringValue)
        default:
            return ("", nil)
        }
    }
}
