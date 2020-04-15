//
//  PaginatedResponse.swift
//  IsisJungleRocks
//
//  Created by Ígor Yamamoto on 07/06/19.
//  Copyright © 2019 Jungle Devs. All rights reserved.
//

import Foundation

struct PaginatedResponse<T: Codable>: Codable {
    let count: Int
    let previous: String?
    let next: String?
    let results: [T]
}

protocol PaginatedDataSource: AnyObject {
    var isFetching: Bool { get set }
    var fetchedCount: Int { get }
    var totalCount: Int { get set }
    var previous: String? { get set }
    var next: String? { get set }
    func getIndexPathsToReload(newResultsCount: Int) -> [IndexPath]
    func isLoading(for indexPath: IndexPath) -> Bool
    func reset()
}

extension PaginatedDataSource {
    func getIndexPathsToReload(newResultsCount: Int) -> [IndexPath] {
        let startIndex = self.fetchedCount - newResultsCount
        let endIndex = startIndex + newResultsCount
        return (startIndex ..< endIndex).map { IndexPath(row: $0, section: 0) }
    }

    func isLoading(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= fetchedCount
    }
}
