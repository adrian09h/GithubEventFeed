//
//  Commit.swift
//  GithubEvents
//
//  Created by Super MAC on 8/12/19.
//  Copyright © 2019 Adrian R. All rights reserved.
//

import UIKit
import ObjectMapper

struct Commit: Mappable {
    
    var url: String?
    var sha: String?
    var author: User?
    var message: String?

    init?(map: Map) {}
    init() {}
    
    mutating func mapping(map: Map) {
        url <- map["url"]
        sha <- map["sha"]
        author <- map["author"]
        message <- map["message"]
    }
}
