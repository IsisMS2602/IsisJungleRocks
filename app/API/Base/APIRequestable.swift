//
//  APIRequestable.swift
//  IsisJungleRocks
//
//  Created by Ígor Yamamoto on 07/06/19.
//  Copyright © 2019 Jungle Devs. All rights reserved.
//

import Foundation
import Alamofire

protocol APIRequestable {
    associatedtype APIResponse: Decodable
    var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy { get }
    var headers: HTTPHeaders? { get }
    var method: HTTPMethod { get }
    var parameters: Parameters? { get set }
    var url: String { get set }
    func convertResponse(from data: Decodable) -> APIResponse?
    func request(completion: @escaping (APIResult<APIResponse>) -> Void) -> APIRequest?
}
extension APIRequestable {
    public var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy {
        return JSONDecoder.DateDecodingStrategy.iso
    }
    public var headers: HTTPHeaders? {
        guard let token = SessionHelper.shared.authToken else { return HTTPHeaders() }
        return [ "Authorization": "Token \(token)" ]
    }
    static public var isInternetAvailable: Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
    func convertResponse(from data: Decodable) -> APIResponse? {
        return data as? APIResponse
    }
}
extension APIRequestable {
    @discardableResult
    func request(completion: @escaping (APIResult<APIResponse>) -> Void) -> APIRequest? {
        guard Self.isInternetAvailable else {
            completion(.failure(.internetConnection))
            return nil
        }
        let encoding: ParameterEncoding = method == .get ? URLEncoding.default : JSONEncoding.default
        return Alamofire.request(
            url,
            method: method,
            parameters: parameters,
            encoding: encoding,
            headers: headers).responseData { response in
                guard (response.error as NSError?)?.code != NSURLErrorCancelled else {
                    log("[REQUEST ERROR] Cancelled")
                    completion(.failure(.cancelled(response)))
                    return
                }
                guard let statusCode = response.response?.statusCode else {
                    log("[REQUEST ERROR] Could not get status code")
                    completion(.failure(.noStatusCode(response)))
                    return
                }
                guard 200...299 ~= statusCode else {
                    log("[REQUEST ERROR] Status code out of 200...299")
                    completion(.failure(.statusCode(statusCode)))
                    return
                }
                guard let data = response.data else {
                    log("[REQUEST ERROR] Could not get data")
                    completion(.failure(.noData(response)))
                    return
                }
                do {
                    let responseAsObject = try APIResponse.decoded(
                        from: data,
                        dateDecodingStrategy: self.dateDecodingStrategy
                    )
                    guard let convertedResponseAsObject = self.convertResponse(from: responseAsObject) else {
                        log("[REQUEST ERROR] Could not convert response")
                        completion(.failure(.convertRespose(response)))
                        return
                    }
                    completion(.success(convertedResponseAsObject))
                } catch let error as DecodingError {
                    let emptyResponse = APIResponseEmpty()
                    guard let emptyResponseObj = emptyResponse as? APIResponse else {
                        log("[REQUEST ERROR] Could not decode",
                            "Return type on API Request must be of type APIResponseEmpty if response is empty"
                        )
                        completion(.failure(.objectMapping(error, response)))
                        return
                    }
                    completion(.success(emptyResponseObj))
                    return
                } catch {
                    log("[REQUEST ERROR] Could not decode", error)
                    completion(.failure(.objectMapping(error, response)))
                    return
                }
        }
    }
}
