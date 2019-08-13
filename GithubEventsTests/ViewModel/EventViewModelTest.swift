//
//  EventViewModelTest.swift
//  GithubEventsTests
//
//  Created by Super MAC on 8/13/19.
//  Copyright © 2019 Adrian R. All rights reserved.
//

import Quick
import Nimble
import RxSwift
@testable import GithubEvents

class EventViewModelTest: QuickSpec {
    
    override func spec() {
        var viewModel: EventsViewModel!
        var provider: GithubAPINetworking!
        var disposeBag: DisposeBag!
        
        beforeEach {
            provider = GithubAPINetworking(githubProvider: GithubNetworking.githubNetworking())
            disposeBag = DisposeBag()
        }
        
        afterEach {
            viewModel = nil // Force viewModel to deallocate and stop syncing.
        }
        let title = "Events"

        describe("events list") {
            it("events") {
                viewModel = EventsViewModel(provider: provider)
                self.testViewModel(viewModel: viewModel, title: title, itemsPerPage: 0, disposeBag: disposeBag)
            }
            
        }
    }
    
    func testViewModel(viewModel: EventsViewModel, title: String, itemsPerPage: Int, disposeBag: DisposeBag) {
        let headerRefresh = PublishSubject<Void>()
        let footerRefresh = PublishSubject<Void>()
        let keywordTrigger = PublishSubject<String>()
        
        let input = EventsViewModel.Input(headerRefresh: headerRefresh,
                                          footerRefresh: footerRefresh,
                                          keywordTrigger: keywordTrigger.asDriver(onErrorJustReturn: ""))
        let output = viewModel.transform(input: input)
        
        // test pagination
        expect(output.items.value.count) == 0
        expect(viewModel.page) == 1
        headerRefresh.onNext(())
        expect(output.items.value.count) == itemsPerPage * viewModel.page
        expect(viewModel.page) == 1
        footerRefresh.onNext(())
        expect(output.items.value.count) == itemsPerPage * viewModel.page
        expect(viewModel.page) == 2
        
    }
}
