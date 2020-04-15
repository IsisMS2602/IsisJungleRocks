//
//  UIViewControllerArray.swift
//  IsisJungleRocks
//
//  Created by Antonio Duarte on 2/2/18.
//  Copyright © 2018 Jungle Devs. All rights reserved.
//

import Foundation
import UIKit

extension Array where Element: UIViewController {
    func getViewController<T>(ofType type: T.Type) -> T? {
        return Array.getViewController(fromViewControllers: self, type: type)
    }

    static func getViewController<T>(fromViewControllers viewControllers: [UIViewController]?, type: T.Type) -> T? {
        guard let viewControllerArray = viewControllers else { return nil }
        for viewController in viewControllerArray {
            if viewController is T {
                return viewController as? T
            }
            if !viewController.children.isEmpty {
                if let childViewController = getViewController(fromViewControllers: viewController.children, type: type) {
                    return childViewController
                }
            }
        }
        return nil
    }
}
