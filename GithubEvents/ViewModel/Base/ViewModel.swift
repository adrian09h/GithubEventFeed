//
//  ViewModel.swift
//  GithubEvents
//
//  Created by Super MAC on 8/13/19.
//  Copyright © 2019 Adrian R. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ObjectMapper
import NSObject_Rx
import Moya

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}

class ViewModel: NSObject {
    
    let provider: GithubAPINetworking
    
    var page = 1
    
    let loading = ActivityIndicator()
    let headerLoading = ActivityIndicator()
    let footerLoading = ActivityIndicator()
    
    let error = ErrorTracker()
    let parsedError = PublishSubject<ApiError>()
    
    init(provider: GithubAPINetworking) {
        self.provider = provider
        super.init()
        
        error.asObservable().map { (error) -> ApiError? in
            do {
                let errorResponse = error as? MoyaError
                if let body = try errorResponse?.response?.mapJSON() as? [String: Any],
                    let errorResponse = Mapper<ErrorResponse>().map(JSON: body) {
                    return ApiError.serverError(response: errorResponse)
                }
            } catch {
                print(error)
            }
            return nil
            }.filterNil().bind(to: parsedError).disposed(by: rx.disposeBag)
        
        error.asDriver().drive(onNext: { (error) in
            print("\(error)")
        }).disposed(by: rx.disposeBag)
    }
    
    deinit {
        print("\(type(of: self)): Deinited")
    }
}
