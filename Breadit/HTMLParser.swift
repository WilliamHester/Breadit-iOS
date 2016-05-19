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
    var links = [Link]()
    var i = 0
    
    init(escapedHtml html: String, font: UIFont) {
        self.font = font
        self.attributedString = self.parseHtml(html.decodeHTML()
            	.stringByReplacingOccurrencesOfString("\n", withString: "").trimmed())
    }

    private func parseHtml(text: String) -> NSAttributedString {
        let html = try! XMLDocument(string: text, encoding: NSUTF8StringEncoding)
        let string = generateString(html.root!, attributedString: NSMutableAttributedString())
        var end = string.length - 1
        while end > 0 && (string.string.hasSuffix("\n") || string.string.hasSuffix(" ")) {
            string.deleteCharactersInRange(NSMakeRange(end, 1))
            end = end - 1
        }
        return string
    }
    
    private func generateString(node: XMLNode, attributedString: NSMutableAttributedString) -> NSMutableAttributedString {
        if node.type == XMLNodeType.Text {
            attributedString.appendAttributedString(NSAttributedString(string: node.stringValue,
                attributes: [NSForegroundColorAttributeName: Colors.textColor]))
            return attributedString
        }
        
        if let element = node as? XMLElement {
            var index = 1
            var prefix: NSAttributedString {
                if element.tag == "ul" {
                    return NSAttributedString(string: "• ",
                  			attributes: [NSForegroundColorAttributeName: Colors.textColor])
                } else if element.tag == "ol" {
                    return NSAttributedString(string: "\(index). ",
                  			attributes: [NSForegroundColorAttributeName: Colors.textColor])
                } else {
                    return NSAttributedString(string: "")
                }
            }
        	for child in element.childNodes(ofTypes: [.Element, .Text]) {
                attributedString.appendAttributedString(prefix)
            	attributedString.appendAttributedString(generateString(child,
                    	attributedString: NSMutableAttributedString()))
                index += 1
            }

            if attributedString.length > 0 {
                
                let attributes = getAttributesFromTag(element, string: attributedString)
                let range = NSMakeRange(0, attributedString.length)
                attributedString.addAttributes(attributes, range: range)
            }
            
            insertNewLine(element, string: attributedString)
        }
        
        return attributedString
    }
    
    private func getAttributesFromTag(node: XMLElement, string: NSMutableAttributedString) -> [String: AnyObject] {
        guard node.tag != nil else {
            return [:]
        }
        switch node.tag! {
        case "ol":
            fallthrough
        case "ul":
            let style = NSMutableParagraphStyle()
            style.setParagraphStyle(NSParagraphStyle.defaultParagraphStyle())
            style.firstLineHeadIndent = 6.0
            style.headIndent = 6.0
            return [NSParagraphStyleAttributeName: style]
        case "p":
            let style = NSMutableParagraphStyle()
            style.setParagraphStyle(NSParagraphStyle.defaultParagraphStyle())
            style.paragraphSpacing = 6.0
            return [NSParagraphStyleAttributeName: style]
        case "code":
            return [NSFontAttributeName: UIFont(name: "Menlo-Regular", size: font.pointSize)!]
        case "del":
            return [
                    NSStrikethroughStyleAttributeName:
                    NSNumber(integer: NSUnderlineStyle.StyleSingle.rawValue)
            ]
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
            paragraphStyle.firstLineHeadIndent = 6.0
            paragraphStyle.headIndent = 6.0
            paragraphStyle.paragraphSpacing = 6.0
            
            return [
                    NSParagraphStyleAttributeName: paragraphStyle,
                    NSForegroundColorAttributeName: Colors.textColor.colorWithAlphaComponent(0.6)
            ]
        case "a":
            let link = Link(link: node.attr("href") ?? "")
            let color: UIColor
            switch link.linkType {
            case .Normal:
                color = urlColor
            case .Image(_):
                color = imageColor
            case .Reddit(_):
                color = redditColor
            case .YouTube:
                color = youTubeColor
            }
            links.append(link)
            return [
                    NSForegroundColorAttributeName: color,
                    "LinkAttribute": link
            ]
        default:
            return [:]
        }
    }
    
    private func insertNewLine(element: XMLElement, string: NSMutableAttributedString) {
        if element.tag == "li" && !(element.children.count > 0 && element.children[0].tag == "p") ||
            	element.tag == "p" || element.tag == "pre" || element.tag == "h1" ||
                element.tag == "h2" || element.tag == "h3" || element.tag == "h4" ||
            	element.tag == "h5" {
            string.appendAttributedString(NSMutableAttributedString(string: "\n"))
        }
    }
}
