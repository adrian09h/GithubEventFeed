//
//  EventTableViewCell.swift
//  GithubEvents
//
//  Created by Super MAC on 8/13/19.
//  Copyright © 2019 Adrian R. All rights reserved.
//

import UIKit
import RxSwift

class EventTableViewCell: BaseTableViewCell {

    override func makeUI() {
        super.makeUI()
        titleLabel.numberOfLines = 2
        secondDetailLabel.numberOfLines = 0
        leftImageView.cornerRadius = 25
    }
    
    override func bind(to viewModel: DefaultTableViewCellViewModel) {
        super.bind(to: viewModel)
        cellDisposeBag = DisposeBag()        
    }

}
