//
//  LandingViewController.swift
//  IsisJungleRocks
//
//  Created by Antonio Duarte on 2/2/18.
//  Copyright © 2018 Jungle Devs. All rights reserved.
//

import UIKit

class LandingViewController: BaseViewController, StoryboardLoadable {

    // MARK: Static

    static func initModule() -> LandingViewController {
        let viewController = loadFromStoryboard()
        return viewController
    }

    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
