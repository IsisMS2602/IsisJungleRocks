//
//  Range.swift
//  IsisJungleRocks
//
//  Created by Andrio Frizon on 6/22/18.
//  Copyright © 2018 Jungle Devs. All rights reserved.
//

import Foundation

extension Range where Bound == String.Index {
    var nsRange: NSRange {
        return NSRange(
//            location: self.lowerBound.encodedOffset,
//            length: self.upperBound.encodedOffset -
//                self.lowerBound.encodedOffset
        )
    }
}
