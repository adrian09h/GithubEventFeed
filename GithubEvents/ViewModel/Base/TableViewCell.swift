//
//  TableViewCell.swift
//  GithubEvents
//
//  Created by Super MAC on 8/13/19.
//  Copyright © 2019 Adrian R. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SwifterSwift

class TableViewCell: UITableViewCell {
    
    var cellDisposeBag = DisposeBag()
    
    var isSelection = false
    var selectionColor: UIColor? {
        didSet {
            setSelected(isSelected, animated: true)
        }
    }
    
    lazy var containerView: View = {
        let view = View()
        view.backgroundColor = .white
        view.cornerRadius = 5
        self.addSubview(view)
        view.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets(horizontal: self.inset*2, vertical: self.inset))
        })
        return view
    }()
    
    lazy var stackView: StackView = {
        let subviews: [UIView] = []
        let view = StackView(arrangedSubviews: subviews)
        view.axis = .horizontal
        view.alignment = .center
        self.containerView.addSubview(view)
        view.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview().inset(inset)
        })
        return view
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        makeUI()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        backgroundColor = selected ? selectionColor : UIColor.Material.grey100
    }
    
    func makeUI() {
        layer.masksToBounds = true
        selectionStyle = .none
        backgroundColor = UIColor.Material.grey100
        
        updateUI()
    }
    
    func updateUI() {
        setNeedsDisplay()
    }
}

extension Reactive where Base: TableViewCell {
    
    var selectionColor: Binder<UIColor?> {
        return Binder(self.base) { view, attr in
            view.selectionColor = attr
        }
    }
}
