//
//  Label.swift
//  GithubEvents
//
//  Created by Super MAC on 8/13/19.
//  Copyright © 2019 Adrian R. All rights reserved.
//

import UIKit

class Label: UILabel {
    
    var textInsets = UIEdgeInsets.zero {
        didSet { invalidateIntrinsicContentSize() }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        makeUI()
    }
    
    func makeUI() {
        layer.masksToBounds = true
        numberOfLines = 1
        //        cornerRadius = Configs.BaseDimensions.cornerRadius
        updateUI()
    }
    
    func updateUI() {
        setNeedsDisplay()
    }
}
