//
//  NibLoadable.swift
//  IsisJungleRocks
//
//  Created by Ígor Yamamoto on 02/04/19.
//  Copyright © 2018 Jungle Devs. All rights reserved.
//

import UIKit

/// Loads a .xib file with the same filename as the custom UIView class name,
/// i.e. "class FoobarView" loads "FoobarView.xib"
protocol NibLoadable {
    static var nibName: String { get }
    static var nib: UINib { get }
    static func loadFromNib() -> Self
    func setupNibContent()
}

extension NibLoadable where Self: UIView {
    static var nibName: String {
        return String(describing: self)
    }

    static var nib: UINib {
        return UINib(nibName: Self.nibName, bundle: Bundle(for: self))
    }

    static func loadFromNib() -> Self {
        guard let view = Self.nib.instantiate(withOwner: nil, options: nil).first as? Self else {
            fatalError("Could not load view of type `\(self)` from nib `\(Self.nibName)`")
        }
        return view
    }

    func setupNibContent() {
        guard let view = Self.nib.instantiate(withOwner: self, options: nil).first as? UIView else {
            fatalError("Could not load view of type `\(self)` from nib `\(Self.nibName)`")
        }
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
    }
}
