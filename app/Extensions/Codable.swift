//
//  Codable.swift
//  IsisJungleRocks
//
//  Created by Ígor Yamamoto on 28/03/19.
//  Copyright © 2019 Jungle Devs. All rights reserved.
//

import Foundation
import Alamofire

extension Encodable {
    var asData: Data? {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.dateEncodingStrategy = .iso8601
        return try? encoder.encode(self)
    }

    var asParameters: Parameters? {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.dateEncodingStrategy = .iso8601
        guard let data = try? encoder.encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap {
            $0 as? [String: Any]
        }
    }
}

extension Decodable {
    static func decoded(from data: Data, dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .iso) throws -> Self {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = dateDecodingStrategy
        do {
            return try decoder.decode(self, from: data)
        } catch {
            dump(error)
            throw error
        }
    }
}
