//
//  User.swift
//  GithubEvents
//
//  Created by Super MAC on 8/12/19.
//  Copyright © 2019 Adrian R. All rights reserved.
//

import UIKit
import ObjectMapper

enum UserType: String {
    case user = "User"
    case organization = "Organization"
}

struct User: Mappable {
    
    var id: String?
    var type: UserType = .user
    var avatarUrl: String?  // A URL pointing to the user's public avatar.
    var login: String?  // The username used to login.
    var email: String?  // The user's publicly visible profile email.
    var name: String?  // The user's public profile name.

    init?(map: Map) {}
    init() {}
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        avatarUrl <- map["avatar_url"]
        login <- map["login"]
        type <- map["type"]
        email <- map["email"]
        name <- map["name"]
    }
}
extension User: Equatable {
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.login == rhs.login
    }
}
