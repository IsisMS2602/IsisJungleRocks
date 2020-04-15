//
//  Optional+String.swift
//  IsisJungleRocks
//
//  Created by Antonio Duarte on 2/2/18.
//  Copyright © 2018 Jungle Devs. All rights reserved.
//

extension Optional where Wrapped == String {
    func convertNilToEmptyString() -> Any {
        return self == nil ? "" : self!
    }
}
