//
//  BodyLabel.swift
//  Breadit
//
//  Created by William Hester on 5/9/16.
//  Copyright © 2016 William Hester. All rights reserved.
//

import UIKit

class BodyLabel: UILabel {

    // MARK: - public properties
    weak var delegate: BodyLabelDelegate?

    @IBInspectable var lineSpacing: Float = 0 {
        didSet {
            updateTextStorage()
        }
    }
    
    // MARK: - public methods
    func handleURLTap(handler: (NSURL) -> ()) {
        urlTapHandler = handler
    }
    
    // MARK: - override UILabel properties
    override var text: String? {
        didSet {
            updateTextStorage()
        }
    }
    
    override var attributedText: NSAttributedString? {
        didSet {
            updateTextStorage()
        }
    }
    
    override var font: UIFont! {
        didSet {
            updateTextStorage()
        }
    }
    
    override var textColor: UIColor! {
        didSet {
            updateTextStorage()
        }
    }
    
    override var textAlignment: NSTextAlignment {
        didSet {
            updateTextStorage()
        }
    }
    
    override var numberOfLines: Int {
        didSet {
            textContainer.maximumNumberOfLines = numberOfLines
        }
    }
    
    override var lineBreakMode: NSLineBreakMode {
        didSet {
            textContainer.lineBreakMode = lineBreakMode
        }
    }
    
    // MARK: - init functions
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLabel()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updateTextStorage()
    }
    
//    override func textRectForBounds(bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
//        let size = CGSize(width: frame.width, height: CGFloat.max)
//        var rect = attributedText!.boundingRectWithSize(size, options: .UsesLineFragmentOrigin,
//        		context: nil)
//        rect.size.height += 1.0 // mild hack to make sure that the last line isn't truncated
//        return rect
//    }
    
    override func drawTextInRect(rect: CGRect) {
        let range = NSRange(location: 0, length: textStorage.length)
        
        textContainer.size = rect.size
        
        layoutManager.drawBackgroundForGlyphRange(range, atPoint: CGPoint.zero)
        layoutManager.drawGlyphsForGlyphRange(range, atPoint: CGPoint.zero)
    }
    
    // MARK: - touch events
    func onTouch(touch: UITouch) -> Bool {
        let location = touch.locationInView(self)
        switch touch.phase {
        case .Began, .Moved:
            if let element = elementAtLocation(location) {
                if element.range.location != selectedElement?.range.location ||
                    	element.range.length != selectedElement?.range.length {
                    updateAttributesWhenSelected(false)
                    selectedElement = element
                    updateAttributesWhenSelected(true)
                }
                return true
            } else {
                updateAttributesWhenSelected(false)
                selectedElement = nil
            }
        case .Ended:
            guard let selectedElement = selectedElement else {
                return false
            }

            if let delegate = delegate {
                delegate.bodyLabel(selectedElement.link)
            }
        
            self.updateAttributesWhenSelected(false)
            self.selectedElement = nil
            return true
        case .Cancelled:
            updateAttributesWhenSelected(false)
            selectedElement = nil
        case .Stationary:
            break
        }
        
        return false
    }
    
    // MARK: - private properties
    private var urlTapHandler: ((NSURL) -> ())?

    private var selectedElement: (range: NSRange, link: Link)?
    private var heightCorrection: CGFloat = 0
    private lazy var textStorage = NSTextStorage()
    private lazy var layoutManager = NSLayoutManager()
    private lazy var textContainer = NSTextContainer()
    var links: [Link]?

    // MARK: - helper functions
    private func setupLabel() {
        textStorage.addLayoutManager(layoutManager)
        layoutManager.addTextContainer(textContainer)
        textContainer.lineFragmentPadding = 0
        textContainer.lineBreakMode = lineBreakMode
        textContainer.maximumNumberOfLines = numberOfLines
        userInteractionEnabled = true
    }
    
    private func updateTextStorage() {
        guard let attributedText = attributedText
            where attributedText.length > 0 else {
                return
        }
        textStorage.setAttributedString(attributedText)
        setNeedsDisplay()
    }
    
    private func updateAttributesWhenSelected(isSelected: Bool) {
        guard let selectedElement = selectedElement else {
            return
        }
        
        var attributes = textStorage.attributesAtIndex(0, effectiveRange: nil)
        if isSelected {
            switch selectedElement.link.linkType {
            case .Image(_): attributes[NSForegroundColorAttributeName] = selectedImageColor
            case .Reddit(_): attributes[NSForegroundColorAttributeName] = selectedRedditColor
            case .YouTube: attributes[NSForegroundColorAttributeName] = selectedYouTubeColor
            case .Normal: attributes[NSForegroundColorAttributeName] = selectedUrlColor
            }
        } else {
            switch selectedElement.link.linkType {
            case .Image(_): attributes[NSForegroundColorAttributeName] = imageColor
            case .Reddit(_): attributes[NSForegroundColorAttributeName] = redditColor
            case .YouTube: attributes[NSForegroundColorAttributeName] = youTubeColor
            case .Normal: attributes[NSForegroundColorAttributeName] = urlColor
            }
        }
        
        textStorage.addAttributes(attributes, range: selectedElement.range)
        
        setNeedsDisplay()
    }
    
    func elementAtLocation(location: CGPoint) -> (range: NSRange, link: Link)? {
        guard textStorage.length > 0 else {
            return nil
        }
        
        var correctLocation = location
        correctLocation.y -= heightCorrection
        let boundingRect = layoutManager.boundingRectForGlyphRange(NSRange(location: 0, length: textStorage.length), inTextContainer: textContainer)
        guard boundingRect.contains(correctLocation) else {
            return nil
        }
        
        let index = layoutManager.glyphIndexForPoint(correctLocation, inTextContainer: textContainer)
        let attrs = textStorage.attributesAtIndex(index, effectiveRange: nil)
        
        if let link = attrs["LinkAttribute"] as? Link {
            var range = NSRange()
            textStorage.attribute(NSForegroundColorAttributeName, atIndex: index,
                                  effectiveRange: &range)
            return (range, link)
        }
        
        return nil
    }
    
    
    //MARK: - Handle UI Responder touches
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        if onTouch(touch) {
            return
        }
        super.touchesBegan(touches, withEvent: event)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        if onTouch(touch) {
            return
        }
        super.touchesMoved(touches, withEvent: event)
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        guard let touch = touches?.first else {
            return
        }
        onTouch(touch)
        super.touchesCancelled(touches, withEvent: event)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        if onTouch(touch) {
            return
        }
        super.touchesEnded(touches, withEvent: event)
    }
}

extension BodyLabel: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer,
			shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer,
    		shouldRequireFailureOfGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer,
    		shouldBeRequiredToFailByGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}