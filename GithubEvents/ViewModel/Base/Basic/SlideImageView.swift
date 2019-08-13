//
//  SlideImageView.swift
//  GithubEvents
//
//  Created by Super MAC on 8/13/19.
//  Copyright © 2019 Adrian R. All rights reserved.
//

import UIKit
import ImageSlideshow

class SlideImageView: ImageSlideshow {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        makeUI()
    }
    
    func makeUI() {
        contentScaleMode = .scaleAspectFit
        contentMode = .scaleAspectFill
        backgroundColor = UIColor.Material.grey100
        borderWidth = 1
        borderColor = .white
        slideshowInterval = 3
        hero.modifiers = [.arc]
        activityIndicator = DefaultActivityIndicator(style: .white, color: UIColor.red)
    }
    
    func setSources(sources: [URL]) {
        setImageInputs(sources.map({ (url) -> KingfisherSource in
            KingfisherSource(url: url)
        }))
    }
}
