//
//  GithubAPINetworking.swift
//  GithubEvents
//
//  Created by Super MAC on 8/12/19.
//  Copyright © 2019 Adrian R. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Moya
import Alamofire
import ObjectMapper
import Moya
import Moya_ObjectMapper

private let assetDir: URL = {
    let directoryURLs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return directoryURLs.first ?? URL(fileURLWithPath: NSTemporaryDirectory())
}()
protocol RestAPI {
    func events(page: Int) -> Single<[Event]>
}
enum ApiError: Error {
    case serverError(response: ErrorResponse)
}

class GithubAPINetworking: RestAPI {
    let githubProvider: GithubNetworking
    
    init(githubProvider: GithubNetworking) {
        self.githubProvider = githubProvider
    }
    func events(page: Int) -> Single<[Event]> {
        return requestArray(.events(page: page), type: Event.self)
    }
    private func requestArray<T: BaseMappable>(_ target: GithubAPI, type: T.Type) -> Single<[T]> {
        return githubProvider.request(target)
            .mapArray(T.self)
            .observeOn(MainScheduler.instance)
            .asSingle()
    }

}
protocol ProductAPIType {
    var addXAuth: Bool { get }
}
enum GithubAPI {
    case events(page: Int)
}
extension GithubAPI: TargetType, ProductAPIType {
    
    var baseURL: URL {
        switch self {
        default:
            return URL(string: "https://api.github.com")!
        }
    }
    
    var path: String {
        switch self {
        case .events: return "/events"
        }
    }
    
    var method: Moya.Method {
        switch self {
        default:
            return .get
        }
    }
    
    var headers: [String: String]? {
        return ["Cache-Control": "no-cache", "cache-control": "no-cache"]
    }
    
    var parameters: [String: Any]? {
        var params: [String: Any] = [:]
        switch self {
        case .events(let page):
            params["page"] = page
        }
        return params
    }
    
    public var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    var localLocation: URL {
        return assetDir
    }
    
    var downloadDestination: DownloadDestination {
        return { _, _ in return (self.localLocation, .removePreviousFile) }
    }
    
    public var task: Task {
        switch self {
        default:
            if let parameters = parameters {
                return .requestParameters(parameters: parameters, encoding: parameterEncoding)
            }
            return .requestPlain
        }
    }
    
    var sampleData: Data {
        var dataUrl: URL?
        switch self {
            case .events: dataUrl = R.file.eventsJson()
        }
        if let url = dataUrl, let data = try? Data(contentsOf: url) {
            return data
        }
        return Data()
    }
    
    var addXAuth: Bool {
        switch self {
        default: return true
        }
    }
}
