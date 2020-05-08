//
//  Projects.swift
//  IsisJungleRocks
//
//  Created by Isis Silva on 4/22/20.
//  Copyright © 2020 Jungle Devs. All rights reserved.
//

import Foundation

struct Project: Codable {
    let name: String
    let image: String
    let key: String
}

//struct WorkLog: Codable {
//    let id: Int?
//    let category: String
//    let workedAt: String?
//    let timeSpent: Int
//    let createdAt: String?
//    let updatedAt: String?
//    let issue: Issue?
//}
//    struct Issue: Codable {
//        let id: Int?
//        let key: String?
//        let projectKey: String?
//        let sprint: Int?
//    }
struct WorkLog: Codable {
    let id: Int?
    let category: String
    let workedAt: String?
    let timeSpent: Int
    let createdAt: String?
    let author: Author?
    let issue: Issue?
}
struct Issue: Codable {
    let id: Int?
    let key: String?
    let projectKey: String?
    let sprint: Int?
    let components: [String]?
}

struct Author: Codable {
    let id: Int
    let name: String
}
