//
//  RootRouter.swift
//  IsisJungleRocks
//
//  Created by Antonio Duarte on 2/2/18.
//  Copyright © 2018 Jungle Devs. All rights reserved.
//

import UIKit

final class RootRouter {

    // MARK: Static
    static func initModule() -> RootRouter {
        return RootRouter()
    }
    // MARK: Actions
    func presentInitialScreen() {
        if SessionHelper.shared.isUserLogged {
            presentCoreScreen()
        } else {
            presentLandingScreen()
        }
    }
    // MARK: Private
    private func presentLandingScreen() {
        let landingViewController = LandingViewController.initModule()
        presentAsRoot(landingViewController)
    }
    private func presentCoreScreen() {
        let coreViewController = CoreViewController.initModule()
        presentAsRoot(coreViewController)
    }
}
private extension RootRouter {
    func presentAsRoot(_ viewController: UIViewController) {
        guard let window = AppDelegate.shared.window else { return }
        window.backgroundColor = .white
        window.makeKeyAndVisible()
        let navigationController = UINavigationController(rootViewController: viewController)
        window.rootViewController = navigationController
    }
}
