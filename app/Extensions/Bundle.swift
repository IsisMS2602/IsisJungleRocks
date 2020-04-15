//
//  Bundle.swift
//  IsisJungleRocks
//
//  Created by Antonio Duarte on 2/2/18.
//  Copyright © 2018 Jungle Devs. All rights reserved.
//

import Foundation

extension Bundle {
    var versionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }

    var buildNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }

    var buildDescription: String {
        var description = ""
        if let version = versionNumber {
            description += version + " "
        }
        if let build = buildNumber {
            description += "(" + build + ")"
        }
        return description
    }
}
