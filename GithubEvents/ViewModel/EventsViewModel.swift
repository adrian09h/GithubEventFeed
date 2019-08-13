//
//  EventsViewModel.swift
//  GithubEvents
//
//  Created by Super MAC on 8/13/19.
//  Copyright © 2019 Adrian R. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources

class EventsViewModel: ViewModel, ViewModelType {
    
    struct Input {
        let headerRefresh: Observable<Void>
        let footerRefresh: Observable<Void>
        let keywordTrigger: Driver<String>
        let textDidBeginEditing: Driver<Void>
    }
    
    struct Output {
        let items: BehaviorRelay<[EventTableViewCellViewModel]>
        let textDidBeginEditing: Driver<Void>
    }
    
    let isSearch = BehaviorRelay(value: false)
    let keyword = BehaviorRelay(value: "")
    func transform(input: Input) -> Output {
        let elementsTotal = BehaviorRelay<[EventTableViewCellViewModel]>(value: [])
        let elements = BehaviorRelay<[EventTableViewCellViewModel]>(value: [])
        let textDidBeginEditing = input.textDidBeginEditing
        input.keywordTrigger.skip(1).debounce(DispatchTimeInterval.milliseconds(500)).distinctUntilChanged().asObservable()
            .bind(to: keyword).disposed(by: rx.disposeBag)
        keyword.flatMapLatest { (keyword) -> Observable<Bool> in
            return keyword.isEmpty ? Observable.just(false) : Observable.just(true)
        }.asObservable().bind(to: isSearch).disposed(by: rx.disposeBag)
        keyword.flatMapLatest { (keyword) -> Observable<[EventTableViewCellViewModel]> in
            if keyword.isEmpty {
                return Observable.just(elementsTotal.value)
            }
                return Observable.just(elementsTotal.value.filter({ (model) -> Bool in
                    return (model.event.actor?.login?.lowercased().contains(keyword.lowercased()))!
                }))
        }
            .subscribe(onNext: { (items) in
                elements.accept(items)
            }).disposed(by: rx.disposeBag)
        
        input.headerRefresh.flatMapLatest({ [weak self] () -> Observable<[EventTableViewCellViewModel]> in
            guard let self = self else { return Observable.just([]) }
            self.page = 1
            return self.request()
                .trackActivity(self.headerLoading)
        })
            .subscribe(onNext: { (items) in
                elements.accept(items)
                elementsTotal.accept(elements.value)
                if self.isSearch.value {
                    elements.accept(elementsTotal.value.filter({ (model) -> Bool in
                        return (model.event.actor?.login?.lowercased().contains(self.keyword.value.lowercased()))!
                    }))
                }
            }).disposed(by: rx.disposeBag)
        
        input.footerRefresh.flatMapLatest({ [weak self] () -> Observable<[EventTableViewCellViewModel]> in
            guard let self = self else { return Observable.just([]) }
            self.page += 1
            return self.request()
                .trackActivity(self.footerLoading)
        })
            .subscribe(onNext: { (items) in
                elements.accept(elementsTotal.value + items)
                elementsTotal.accept(elements.value)
                if self.isSearch.value {
                    elements.accept(elementsTotal.value.filter({ (model) -> Bool in
                        return (model.event.actor?.login?.lowercased().contains(self.keyword.value.lowercased()))!
                    }))
                }
            }).disposed(by: rx.disposeBag)
        Observable<Int>.timer(RxTimeInterval.seconds(0), period: RxTimeInterval.seconds(10), scheduler: MainScheduler.instance).flatMapLatest { [weak self] (_) -> Observable<[EventTableViewCellViewModel]> in
            guard let self = self else { return Observable.just([]) }
            self.page = 1
            return self.request()
                .trackActivity(self.loading)
        }
            .subscribe(onNext: { (items) in
                elements.accept((items + elementsTotal.value).reduce(into: [EventTableViewCellViewModel](), { (array, model) in
                    if !array.contains(where: { (m) -> Bool in
                        return m.event == model.event
                    }) {
                        array.append(model)
                    }
                }))
                elementsTotal.accept(elements.value)
                if self.isSearch.value {
                   elements.accept(elementsTotal.value.filter({ (model) -> Bool in
                        return (model.event.actor?.login?.lowercased().contains(self.keyword.value.lowercased()))!
                    }))
                }
            }).disposed(by: rx.disposeBag)
        return Output(
                      items: elements,
                      textDidBeginEditing: textDidBeginEditing
        )
    }
    
    func request() -> Observable<[EventTableViewCellViewModel]> {
        let request = provider.events(page: page)
        return request
            .trackActivity(loading)
            .trackError(error)
            .map { $0.map({ (event) -> EventTableViewCellViewModel in
                let viewModel = EventTableViewCellViewModel(with: event)
                return viewModel
            })}
    }
}
