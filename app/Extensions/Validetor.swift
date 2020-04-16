//
//  Validetor.swift
//  IsisJungleRocks
//
//  Created by Isis Silva on 4/15/20.
//  Copyright © 2020 Jungle Devs. All rights reserved.
//

import Foundation

func isEmailValid(email: String) -> Bool {
    do {
        if try NSRegularExpression(pattern: "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$", options: .caseInsensitive).firstMatch(in: email, options: [], range: NSRange(location: 0, length: email.count)) == nil {
            return false
        }
    } catch {
        return false
    }
    return true
}
func isPasswordValid(password: String) -> Bool {
    do {
        if try NSRegularExpression(pattern: "^[A-Za-z0-9.-]{1,}$", options: .caseInsensitive).firstMatch(in: password, options: [], range: NSRange(location: 0, length: password.count)) == nil {
            return false
        }
    } catch {
        return false
    }
    return true
}
