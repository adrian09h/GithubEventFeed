//
//  EventsViewController.swift
//  GithubEvents
//
//  Created by Super MAC on 8/13/19.
//  Copyright © 2019 Adrian R. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

private let reuseIdentifier = R.reuseIdentifier.eventTableViewCell.identifier

enum EventSegments: Int {
    case received, performed
    
    var title: String {
        switch self {
        case .received: return "Received"
        case .performed: return "Performed"
        }
    }
}

class EventsViewController: TableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func makeUI() {
        super.makeUI()
        
        searchBar.placeholder = "Search by user name"
        stackView.insertArrangedSubview(searchBar, at: 0)
        tableView.register(R.nib.eventTableViewCell)
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        guard let viewModel = viewModel as? EventsViewModel else { return }
        
        let input = EventsViewModel.Input(headerRefresh: headerRefreshTrigger,
                                          footerRefresh: footerRefreshTrigger,
                                          keywordTrigger: searchBar.rx.text.orEmpty.asDriver(),
                                          textDidBeginEditing: searchBar.rx.textDidBeginEditing.asDriver()
        )
        let output = viewModel.transform(input: input)
        
        viewModel.loading.asObservable().bind(to: isLoading).disposed(by: rx.disposeBag)
        viewModel.headerLoading.asObservable().bind(to: isHeaderLoading).disposed(by: rx.disposeBag)
        viewModel.footerLoading.asObservable().bind(to: isFooterLoading).disposed(by: rx.disposeBag)
        
        output.items.asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(cellIdentifier: reuseIdentifier, cellType: EventTableViewCell.self)) { tableView, viewModel, cell in
                cell.bind(to: viewModel)
            }.disposed(by: rx.disposeBag)
        
        viewModel.error.asDriver().drive(onNext: { [weak self] (error) in
            self?.showAlert(title: "Error", message: error.localizedDescription)
        }).disposed(by: rx.disposeBag)
    }
}
