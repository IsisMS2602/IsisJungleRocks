//
//  User.swift
//  IsisJungleRocks
//
//  Created by Antonio Duarte on 2/2/18.
//  Copyright © 2018 Jungle Devs. All rights reserved.
//

import Foundation

struct WorkLogResponse: Codable {
    let workLog: String?
}

struct UserResponse: Codable {
    let user: User
    let key: String
}

struct User: Codable {
    let id: Int?
    let email: String?
    let password: String?
    let firstName: String?
    let lastName: String?
    let name: String?
    let githubUsername: String?
    let role: String?
    let availability: String?
    let cnpj: String?
    let bank: String?
    let agency: String?
    let account: String?
    let accountName: String?
    let react: Int?
    let reactNative: Int?
    let ios: Int?
    let android: Int?
    let numberOfHoursWorkingPerWeek: Int?
    let dateJoined: String?
    let dateLeft: String?
    let picture: String?
    var firstname: String? {return firstName!}
    var lastname: String? {return lastName!}
    var githubusername: String? {return githubUsername!}
    var accountname: String? {return accountName ?? " "}
    var reactnative: Int? {return reactNative ?? 0}
    var numberofHoursWorkingPerWeek: Int? {return numberOfHoursWorkingPerWeek ?? 0}
    var datejoined: String? {return dateJoined ?? " "}
    var dateleft: String? {return dateLeft ?? " "}
}
