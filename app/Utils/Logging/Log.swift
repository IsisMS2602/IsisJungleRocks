//
//  Log.swift
//  IsisJungleRocks
//
//  Created by Ígor Yamamoto on 01/05/19.
//  Copyright © 2019 Jungle Devs. All rights reserved.
//

import Foundation

func log(_ items: Any...) {
    #if DEBUG
        print(items)
    #endif
}
