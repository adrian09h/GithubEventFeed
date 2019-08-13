//
//  Application.swift
//  GithubEvents
//
//  Created by Super MAC on 8/13/19.
//  Copyright © 2019 Adrian R. All rights reserved.
//

import UIKit
import KafkaRefresh

final class Application: NSObject {
    static let shared = Application()
    
    var window: UIWindow?
    
    var provider: GithubAPINetworking?
    let navigator: Navigator
    
    private override init() {
        navigator = Navigator.default
        super.init()
        updateProvider()
        if let defaults = KafkaRefreshDefaults.standard() {
            defaults.headDefaultStyle = .replicatorAllen
            defaults.footDefaultStyle = .replicatorDot
        }

    }
    
    private func updateProvider() {
        let githubProvider = GithubNetworking.githubNetworking()
        let restApi = GithubAPINetworking(githubProvider: githubProvider)
        provider = restApi
    }
    
    func presentInitialScreen(in window: UIWindow?) {
        updateProvider()
        guard let window = window, let provider = provider else { return }
        self.window = window
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let viewModel = EventsViewModel(provider: provider)
            self.navigator.show(segue: .events(viewModel: viewModel), sender: nil, transition: .root(in: window))
        }
    }
}
