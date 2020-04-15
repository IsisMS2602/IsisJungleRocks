//
//  APITypes.swift
//  IsisJungleRocks
//
//  Created by Ígor Yamamoto on 07/06/19.
//  Copyright © 2019 Jungle Devs. All rights reserved.
//

import Foundation
import Alamofire

enum APIError: Error {
    case internetConnection
    case cancelled(_ response: DataResponse<Data>)
    case noStatusCode(_ response: DataResponse<Data>)
    case statusCode(_ statusCode: Int)
    case objectMapping(_ error: Error, _ response: DataResponse<Data>)
    case noData(_ response: DataResponse<Data>)
    case convertRespose(_ response: DataResponse<Data>)
}

enum APIResult<T: Decodable> {
    case success(T)
    case failure(APIError)
}

typealias APIRequest = Request

struct APIResponseEmpty: Codable { }
