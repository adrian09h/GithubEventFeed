//
//  EventTest.swift
//  GithubEventsTests
//
//  Created by Super MAC on 8/13/19.
//  Copyright © 2019 Adrian R. All rights reserved.
//

import Quick
import Nimble
import Moya_ObjectMapper
@testable import GithubEvents

class EventTest: QuickSpec {
    
    override func spec() {
        
        let type = EventType.create
        let createdAt = "2019-08-13T05:36:45Z"
        let refType = CreateEventType.branch
        let actorAvatar_url = "https://avatars.githubusercontent.com/u/53625595?"
        let actorLogin = "izycisner"
        
        describe("converts from JSON") {
            it("Event") {
                let actorDic = [
                    "id": 53625595,
                    "login": "izycisner",
                    "display_login": "izycisner",
                    "gravatar_id": "",
                    "url": "https://api.github.com/users/izycisner",
                    "avatar_url": "https://avatars.githubusercontent.com/u/53625595?"
                    ] as [String : Any]
                let repoDic = [
                    "id": 200942780,
                    "name": "haley-hayashi/3BrainCells",
                    "url": "https://api.github.com/repos/haley-hayashi/3BrainCells"
                    ] as [String : Any]
                let payloadDic = [
                    "ref": "SolsticeV1",
                    "ref_type": "branch",
                    "master_branch": "master",
                    "description": "group for our game :)",
                    "pusher_type": "user"
                ]
                let data = [
                    "id": "10198504641",
                    "type": "CreateEvent",
                    "actor": actorDic,
                    "repo": repoDic,
                    "payload": payloadDic,
                    "public": true,
                    "created_at": "2019-08-13T05:36:45Z"
                    ] as [String : Any]
                let event = Event.init(JSON: data)
                
                expect(event?.type) == type
                expect(event?.createdAt) == createdAt.toISODate()?.date
                expect((event?.payload as? CreatePayload)?.refType) == refType
                expect(event?.actor?.avatarUrl) == actorAvatar_url
                expect(event?.actor?.login) == actorLogin
            }
        }
    }
}
