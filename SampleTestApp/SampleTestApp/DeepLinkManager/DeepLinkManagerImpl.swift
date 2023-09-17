//
//  DeepLinkManagerImpl.swift
//  SampleTestApp
//
//  Created by Omeir on 16/09/2023.
//

import Foundation

enum Host: String {
    case web3Auth = "web3auth.com"
    case twilio = "twilio.com"
}

class DeepLinkManagerImpl: DeepLinkManagerProtocol {
    
    private let router: Router

    private init(router: Router) {
        self.router = router
    }

    func handleDeepLink(_ url: URL) {
        guard let host = url.host, let hostType = Host(rawValue: host) else {
            showDefaultView()
            return
        }

        switch hostType {
        case .web3Auth:
            handleWeb3AuthFlow(url)
        case .twilio:
            handleUserProfileFlow(url)
        }
    }

    private func handleWeb3AuthFlow(_ url: URL) {
        //let parameters = url.queryParameters
        // let authId = parameters["authId"]
        // router.navigateToAuthScreen(authId)
    }

    private func handleUserProfileFlow(_ url: URL) {
        //let parameters = url.queryParameters
        // let userId = parameters["userId"]
        // navigateToUserProfile(userId)
    }

    private func showDefaultView() {

    }
}


