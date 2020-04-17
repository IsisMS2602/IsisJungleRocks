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
    struct Login: APIRequestable {
        typealias APIResponse = UserResponse
        var headers: HTTPHeaders?
        var method: HTTPMethod = .post
        var parameters: Parameters?
        var url = "https://api.jungle.rocks/api/v1/login/"
        init(email: String, password: String) {
            parameters = [
                "email": email,
                "password": password
            ]
        }
    }
}
