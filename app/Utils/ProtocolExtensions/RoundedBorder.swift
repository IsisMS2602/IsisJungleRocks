//
//  RoundedBorder.swift
//  IsisJungleRocks
//
//  Created by Antonio Duarte on 2/2/18.
//  Copyright © 2018 Jungle Devs. All rights reserved.
//

import Foundation
import UIKit

protocol RoundedBorder {}

extension RoundedBorder where Self: UIView {
    func makeRounded() {
        layer.cornerRadius = (frame.size.height / 2)
    }
}
