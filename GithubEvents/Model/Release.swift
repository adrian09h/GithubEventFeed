//
//  Release.swift
//  GithubEvents
//
//  Created by Super MAC on 8/12/19.
//  Copyright © 2019 Adrian R. All rights reserved.
//

import UIKit
import ObjectMapper

struct Release: Mappable {
    
    var assets: [Asset]?
    var assetsUrl: String?
    var author: User?
    var body: String?
    var createdAt: Date?
    var draft: Bool?
    var htmlUrl: String?
    var id: Int?
    var name: String?
    var nodeId: String?
    var prerelease: Bool?
    var publishedAt: Date?
    var tagName: String?
    var tarballUrl: String?
    var targetCommitish: String?
    var uploadUrl: String?
    var url: String?
    var zipballUrl: String?
    
    init?(map: Map) {}
    init() {}
    
    mutating func mapping(map: Map) {
        assets <- map["assets"]
        assetsUrl <- map["assets_url"]
        author <- map["author"]
        body <- map["body"]
        createdAt <- (map["created_at"], ISO8601DateTransform())
        draft <- map["draft"]
        htmlUrl <- map["html_url"]
        id <- map["id"]
        name <- map["name"]
        nodeId <- map["node_id"]
        prerelease <- map["prerelease"]
        publishedAt <- (map["published_at"], ISO8601DateTransform())
        tagName <- map["tag_name"]
        tarballUrl <- map["tarball_url"]
        targetCommitish <- map["target_commitish"]
        uploadUrl <- map["upload_url"]
        url <- map["url"]
        zipballUrl <- map["zipball_url"]
    }
}

struct Asset: Mappable {
    
    var browserDownloadUrl: String?
    var contentType: String?
    var createdAt: String?
    var downloadCount: Int?
    var id: Int?
    var label: String?
    var name: String?
    var nodeId: String?
    var size: Int?
    var state: String?
    var updatedAt: String?
    var uploader: User?
    var url: String?
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        browserDownloadUrl <- map["browser_download_url"]
        contentType <- map["content_type"]
        createdAt <- map["created_at"]
        downloadCount <- map["download_count"]
        id <- map["id"]
        label <- map["label"]
        name <- map["name"]
        nodeId <- map["node_id"]
        size <- map["size"]
        state <- map["state"]
        updatedAt <- map["updated_at"]
        uploader <- map["uploader"]
        url <- map["url"]
    }
}
