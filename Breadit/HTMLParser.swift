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
    let font: UIFont
    var links = [(NSRange, String)]()
    
    init(escapedHtml html: String, font: UIFont) {
        self.font = font
        self.attributedString = self.parseHtml(html.decodeHTML().stringByReplacingOccurrencesOfString("\n", withString: ""))
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
                let attributes = getAttributesFromTag(element)
                let range = NSMakeRange(0, attributedString.length)
                if let target = attributes[NSLinkAttributeName] as? String {
                    links.append(range, target)
                }
                attributedString.addAttributes(attributes, range: range)
            }
        }
        
        return attributedString
    }
    
    private func getAttributesFromTag(node: XMLElement) -> [String: AnyObject] {
        guard node.tag != nil else {
            return [:]
        }
        switch node.tag! {
        case "code":
            return [NSFontAttributeName: UIFont(name: "Menlo-Regular", size: 12.0)!]
        case "del":
            return [NSStrikethroughStyleAttributeName:
                NSNumber(integer: NSUnderlineStyle.StyleSingle.rawValue)]
        case "h1":
            return [NSFontAttributeName: UIFont.boldSystemFontOfSize(font.pointSize * 1.20)]
        case "h2":
            return [NSFontAttributeName: UIFont.systemFontOfSize(font.pointSize * 1.20)]
        case "h3":
            return [NSFontAttributeName: UIFont.boldSystemFontOfSize(font.pointSize * 1.1)]
        case "h4":
            return [NSFontAttributeName: UIFont.systemFontOfSize(font.pointSize * 1.1)]
        case "h5":
            fallthrough
        case "strong":
            return [NSFontAttributeName: UIFont.boldSystemFontOfSize(font.pointSize)]
        case "h6":
            return [NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue]
        case "em":
            return [NSFontAttributeName: UIFont.italicSystemFontOfSize(font.pointSize)]
        case "sup":
            return [
                NSFontAttributeName: UIFont.systemFontOfSize(font.pointSize * 0.8),
                NSBaselineOffsetAttributeName: 4
            ]
        case "blockquote":
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.setParagraphStyle(NSParagraphStyle.defaultParagraphStyle())
            paragraphStyle.firstLineHeadIndent = 4.0
            paragraphStyle.headIndent = 4.0
            
            return [
                NSParagraphStyleAttributeName: paragraphStyle,
                NSFontAttributeName: UIFont.italicSystemFontOfSize(12.0)
            ]
        case "a":
            let link = node.attr("href") ?? "Couldn't find link :("
            return [NSLinkAttributeName: link]
        default:
            return [:]
        }
    }
}
