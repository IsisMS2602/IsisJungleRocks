//
//  LocalStoreHelper.swift
//  IsisJungleRocks
//
//  Created by Antonio Duarte on 2/2/18.
//  Copyright © 2018 Jungle Devs. All rights reserved.
//

import UIKit

enum UserDefaultsKeys: String, CaseIterable {
    case user
}

final class LocalStoreHelper {

    private static let defaults = UserDefaults.standard

    static func clearLocalStore() {
        UserDefaultsKeys.allCases.forEach { key in
            defaults.removeObject(forKey: key.rawValue)
        }
    }

    static func save(data: Data, forKey key: UserDefaultsKeys) {
        defaults.set(data, forKey: key.rawValue)
    }

    static func loadData(forKey key: UserDefaultsKeys) -> Data? {
        return defaults.data(forKey: key.rawValue)
    }

    static func removeData(forKey key: UserDefaultsKeys) {
        defaults.removeObject(forKey: key.rawValue)
    }
}
