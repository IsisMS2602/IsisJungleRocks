//
//  AppDelegate.swift
//  IsisJungleRocks
//
//  Created by Antonio Duarte on 2/2/18.
//  Copyright © 2018 Jungle Devs. All rights reserved.
//

import UIKit

#if canImport(AlamofireNetworkActivityLogger)
import AlamofireNetworkActivityLogger
#endif

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: Properties

    var window: UIWindow?

    // swiftlint:disable:next force_cast
    static let shared = UIApplication.shared.delegate as! AppDelegate

    // MARK: Life cycle

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        presentInitialScreen()
        setupLogger()
        return true
    }

    // MARK: Actions

    func presentInitialScreen() {
        let rootRouter = RootRouter.initModule()
        rootRouter.presentInitialScreen()
    }

    // MARK: - Setup

    private func setupLogger() {
        #if canImport(AlamofireNetworkActivityLogger)
        NetworkActivityLogger.shared.level = .debug
        NetworkActivityLogger.shared.startLogging()
        #endif
    }
}
