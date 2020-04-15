//
//  UITapGestureRecognizer.swift
//  IsisJungleRocks
//
//  Created by Andrio Frizon on 6/22/18.
//  Copyright © 2018 Jungle Devs. All rights reserved.
//

import UIKit

extension UITapGestureRecognizer {
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: .zero)
        guard let attributedText = label.attributedText else { return false }
        let textStorage = NSTextStorage(attributedString: attributedText)

        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)

        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode =  label.numberOfLines == 1 ? label.lineBreakMode : .byWordWrapping
        textContainer.maximumNumberOfLines = label.numberOfLines

        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        let textBoundingBox = layoutManager.usedRect(for: textContainer)

        let horizontalFlushFactor: CGFloat!
        switch label.textAlignment {
        case .left, .natural, .justified: horizontalFlushFactor = 0.0
        case .center: horizontalFlushFactor = 0.5
        case .right: horizontalFlushFactor = 1.0
        }

        let textContainerOffset = CGPoint(
            x: (labelSize.width - textBoundingBox.size.width) * horizontalFlushFactor - textBoundingBox.origin.x,
            y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y
        )
        let locationOfTouchInTextContainer = CGPoint(
            x: locationOfTouchInLabel.x - textContainerOffset.x,
            y: locationOfTouchInLabel.y - textContainerOffset.y
        )
        let indexOfCharacter = layoutManager.characterIndex(
            for: locationOfTouchInTextContainer,
            in: textContainer,
            fractionOfDistanceBetweenInsertionPoints: nil
        )

        return NSLocationInRange(indexOfCharacter, targetRange)
    }
}
