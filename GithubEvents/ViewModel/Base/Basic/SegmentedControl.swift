//
//  SegmentedControl.swift
//  GithubEvents
//
//  Created by Super MAC on 8/13/19.
//  Copyright © 2019 Adrian R. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import HMSegmentedControl

class SegmentedControl: HMSegmentedControl {
    
    let segmentSelection = BehaviorRelay<Int>(value: 0)
    
    init() {
        super.init(sectionTitles: [])
        makeUI()
    }
    
    override init(sectionTitles sectiontitles: [String]) {
        super.init(sectionTitles: sectiontitles)
        makeUI()
    }
    
    override init(sectionImages: [UIImage]!, sectionSelectedImages: [UIImage]!) {
        super.init(sectionImages: sectionImages, sectionSelectedImages: sectionSelectedImages)
        makeUI()
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
        
        cornerRadius = 5
        selectionStyle = .box
        selectionIndicatorLocation = .down
        selectionIndicatorBoxOpacity = 0
        selectionIndicatorHeight = 2.0
        segmentEdgeInset = UIEdgeInsets(inset: self.inset)
        indexChangeBlock = { [weak self] index in
            self?.segmentSelection.accept(index)
        }
        snp.makeConstraints { (make) in
            make.height.equalTo(36)
        }
        updateUI()
    }
    
    func updateUI() {
        setNeedsDisplay()
    }
}
