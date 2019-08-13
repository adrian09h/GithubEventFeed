//
//  Event.swift
//  GithubEvents
//
//  Created by Super MAC on 8/12/19.
//  Copyright © 2019 Adrian R. All rights reserved.
//

import UIKit
import ObjectMapper

enum EventType: String {
    case fork = "ForkEvent"
    case commitComment = "CommitCommentEvent"
    case create = "CreateEvent"
    case issueComment = "IssueCommentEvent"
    case issues = "IssuesEvent"
    case member = "MemberEvent"
    case organizationBlock = "OrgBlockEvent"
    case `public` = "PublicEvent"
    case pullRequest = "PullRequestEvent"
    case pullRequestReviewComment = "PullRequestReviewCommentEvent"
    case push = "PushEvent"
    case release = "ReleaseEvent"
    case star = "WatchEvent"
    case unknown = ""
}

struct Event: Mappable {
    
    var actor: User?
    var createdAt: Date?
    var id: String?
    var organization: User?
    var isPublic: Bool?
    var repository: Repository?
    var type: EventType = .unknown
    
    var payload: Payload?
    
    init?(map: Map) {}
    init() {}
    
    mutating func mapping(map: Map) {
        actor <- map["actor"]
        createdAt <- (map["created_at"], ISO8601DateTransform())
        id <- map["id"]
        organization <- map["org"]
        isPublic <- map["public"]
        repository <- map["repo"]
        type <- map["type"]
        
        payload = Mapper<Payload>().map(JSON: map.JSON)
        
        if let fullname = repository?.name {
            let parts = fullname.components(separatedBy: "/")
            repository?.name = parts.last
        }
    }
}

extension Event: Equatable {
    static func == (lhs: Event, rhs: Event) -> Bool {
        return lhs.id == rhs.id
    }
}

class Payload: StaticMappable {
    
    required init?(map: Map) {}
    init() {}
    
    func mapping(map: Map) {}
    
    static func objectForMapping(map: Map) -> BaseMappable? {
        var type: EventType = .unknown
        type <- map["type"]
        switch type {
        case .fork: return ForkPayload()
        case .create: return CreatePayload()
        case .issueComment: return IssueCommentPayload()
        case .issues: return IssuesPayload()
        case .member: return MemberPayload()
        case .pullRequest: return PullRequestPayload()
        case .pullRequestReviewComment: return PullRequestReviewCommentPayload()
        case .push: return PushPayload()
        case .release: return ReleasePayload()
        case .star: return StarPayload()
        default: return Payload()
        }
    }
}

class ForkPayload: Payload {
    
    var repository: Repository?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        repository <- map["payload.forkee"]
    }
}

enum CreateEventType: String {
    case repository
    case branch
    case tag
}

class CreatePayload: Payload {
    
    var ref: String?
    var refType: CreateEventType = .repository
    var masterBranch: String?
    var description: String?
    var pusherType: String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        ref <- map["payload.ref"]
        refType <- map["payload.ref_type"]
        masterBranch <- map["payload.master_branch"]
        description <- map["payload.description"]
        pusherType <- map["payload.pusher_type"]
    }
}

class IssueCommentPayload: Payload {
    
    var action: String?
    var issue: Issue?
    var comment: Comment?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        action <- map["payload.action"]
        issue <- map["payload.issue"]
        comment <- map["payload.comment"]
    }
}

class IssuesPayload: Payload {
    
    var action: String?
    var issue: Issue?
    var repository: Repository?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        action <- map["payload.action"]
        issue <- map["payload.issue"]
        repository <- map["payload.forkee"]
    }
}

class MemberPayload: Payload {
    
    var action: String?
    var member: User?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        action <- map["payload.action"]
        member <- map["payload.member"]
    }
}

class PullRequestPayload: Payload {
    
    var action: String?
    var number: Int?
    var pullRequest: PullRequest?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        action <- map["payload.action"]
        number <- map["payload.number"]
        pullRequest <- map["payload.pull_request"]
    }
}

class PullRequestReviewCommentPayload: Payload {
    
    var action: String?
    var comment: Comment?
    var pullRequest: PullRequest?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        action <- map["payload.action"]
        comment <- map["payload.comment"]
        pullRequest <- map["payload.pull_request"]
    }
}

class PushPayload: Payload {
    
    var ref: String?
    var size: Int?
    var commits: [Commit] = []
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        ref <- map["payload.ref"]
        size <- map["payload.size"]
        commits <- map["payload.commits"]
    }
}

class ReleasePayload: Payload {
    
    var action: String?
    var release: Release?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        action <- map["payload.action"]
        release <- map["payload.release"]
    }
}

class StarPayload: Payload {
    
    var action: String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        action <- map["payload.action"]
    }
}
