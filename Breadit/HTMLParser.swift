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
        	for child in element.childNodes(ofTypes: [.Element, .Text]) {
            	attributedString.appendAttributedString(generateString(child,
                    attributedString: NSMutableAttributedString()))
            }

            if attributedString.length > 0 {
                
                let range = NSMakeRange(0, attributedString.length)
                let attributes = getAttributesFromTag(element)
                attributedString.addAttributes(attributes, range: range)
            }
            
            insertNewLine(element, string: attributedString)
        }
        
        return attributedString
    }
    
    private func getAttributesFromTag(node: XMLElement) -> [String: AnyObject] {
        guard node.tag != nil else {
            return [:]
        }
        switch node.tag! {
//        case "p":
//            return [NSParagraphStyleAttributeName: NSParagraphStyle.defaultParagraphStyle()]
//            return [NSBackgroundColorAttributeName: cycleBackgroundColor()]
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
            paragraphStyle.firstLineHeadIndent = 4.0
            paragraphStyle.headIndent = 4.0
            
            return [
                    NSParagraphStyleAttributeName: paragraphStyle,
                    NSFontAttributeName: UIFont.italicSystemFontOfSize(font.pointSize)
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
    
    private func cycleBackgroundColor() -> UIColor {
        i = (i + 1) % 4
        switch i {
        case 0:
            return UIColor.yellowColor()
        case 1:
            return UIColor.greenColor()
        case 2:
            return UIColor.purpleColor()
        case 3:
            return UIColor.orangeColor()
        default:
            return UIColor.yellowColor()
        }
    }
    
    private func insertNewLine(element: XMLElement, string: NSMutableAttributedString) {
        if element.tag == "li" && element.children[0].tag == "p" || element.tag == "p" ||
            	element.tag == "pre" || element.tag == "h1" {
            string.appendAttributedString(NSMutableAttributedString(string: "\n"))
        }
    }
}
