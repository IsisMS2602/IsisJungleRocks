//
//  StoryboardLoadable.swift
//  IsisJungleRocks
//
//  Created by Ígor Yamamoto on 02/04/19.
//  Copyright © 2019 Jungle Devs. All rights reserved.
//

import Foundation
import UIKit

/// Loads a .storyboard file with the same name as the UIViewController class (without the "ViewController" suffix),
/// i.e. "class FoobarViewController" loads "Foobar.storyboard"
protocol StoryboardLoadable {
    static var storyboard: UIStoryboard { get }
    static var storyboardIdentifier: String { get }
    static var storyboardName: String { get }
    static func loadFromStoryboard() -> Self
}

extension StoryboardLoadable where Self: UIViewController {
    static var storyboard: UIStoryboard {
        return UIStoryboard(name: Self.storyboardName, bundle: nil)
    }

    static var storyboardIdentifier: String {
        return String(describing: self)
    }

    static var storyboardName: String {
        return String(describing: self).replacingOccurrences(of: "ViewController", with: "")
    }

    static func loadFromStoryboard() -> Self {
        guard let viewController = Self.storyboard.instantiateViewController(withIdentifier: Self.storyboardIdentifier) as? Self else {
            fatalError("Could not load ViewController of type `\(self)` with storyboard identifier `\(Self.storyboardIdentifier)`")
        }
        return viewController
    }
}
