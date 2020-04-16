//
//  APIManager.swift
//  IsisJungleRocks
//
//  Created by Isis Silva on 4/15/20.
//  Copyright © 2020 Jungle Devs. All rights reserved.
//

import Foundation
import Alamofire

class APIManager {
    static let URL = "http://api-staging.jungle.rocks/api/v1/login"
    struct GetUser: APIRequestable {
        typealias APIResponse = [User]
        var headers: HTTPHeaders?
        var method: HTTPMethod = .get
        var parameters: Parameters?
        var url: String
        init(email: String, password: String) {
            url = "\(URL)/?email=\(email)&password=\(password)"
        }
    }
}
