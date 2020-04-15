//
//  UIFont.swift
//  IsisJungleRocks
//
//  Created by Antonio Duarte on 2/2/18.
//  Copyright © 2018 Jungle Devs. All rights reserved.
//

import UIKit

extension UIFont {

    // MARK: Static

    static func getFontOrDefault(font: UIFont?, size: CGFloat) -> UIFont {
        guard let font = font else {
            return UIFont.systemFont(ofSize: size)
        }
        return font
    }

    enum FontWeight: String {
        case black = "Black"
        case blackItalic = "BlackItalic"
        case bold = "Bold"
        case boldItalic = "BoldItalic"
        case extraBold = "ExtraBold"
        case extraBoldItalic = "ExtraBoldItalic"
        case extraLight = "ExtraLight"
        case extraLightItalic = "ExtraLightItalic"
        case italic = "Italic"
        case light = "Light"
        case lightItalic = "LightItalic"
        case regular = "Regular"
        case medium = "Medium"
        case mediumItalic = "MediumItalic"
        case semiBold = "SemiBold"
        case semiBoldItalic = "SemiBoldItalic"
        case thin = "Thin"
        case thinItalic = "ThinItalic"
    }

//    private static let primary = "Helvetica"
//
//    // MARK: Helvetica
//
//    class func primary(size: CGFloat, weight: FontWeight) -> UIFont {
//        return getFontOrDefault(font: UIFont(name: "\(primary)-\(weight)", size: size), size: size)
//    }
}
