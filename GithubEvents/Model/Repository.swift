//
//  Repository.swift
//  GithubEvents
//
//  Created by Super MAC on 8/12/19.
//  Copyright © 2019 Adrian R. All rights reserved.
//

import UIKit
import ObjectMapper

struct Repository: Mappable {
    
    var id: String?
    var name: String?  // The name of the repository.
    var url: String?  // The HTTP URL for this repository
    
    init?(map: Map) {}
    init() {}
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        url <- map["url"]
    }
}
extension Repository: Equatable {
    static func == (lhs: Repository, rhs: Repository) -> Bool {
        return lhs.id == rhs.id
    }
}
