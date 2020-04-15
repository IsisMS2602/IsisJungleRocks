//
//  BaseViewController.swift
//  IsisJungleRocks
//
//  Created by Antonio Duarte on 2/2/18.
//  Copyright © 2018 Jungle Devs. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    // MARK: Properties

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    deinit {
        print("Deinit of type \(type(of: self))")
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
