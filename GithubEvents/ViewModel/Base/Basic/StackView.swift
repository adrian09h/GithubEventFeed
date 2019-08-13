//
//  StackView.swift
//  GithubEvents
//
//  Created by Super MAC on 8/13/19.
//  Copyright © 2019 Adrian R. All rights reserved.
//

import UIKit

class StackView: UIStackView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        makeUI()
    }
    
    func makeUI() {
        spacing = inset
        axis = .vertical
        // self.distribution = .fill
        
        updateUI()
    }
    
    func updateUI() {
        setNeedsDisplay()
    }
}
