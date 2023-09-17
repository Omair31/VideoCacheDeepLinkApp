//
//  DeepLinkManagerImpl.swift
//  SampleTestApp
//
//  Created by Omeir on 16/09/2023.
//

import Foundation

class DeepLinkManagerImpl: DeepLinkManagerProtocol {
    
    private let router: Router

    private init(router: Router) {
        self.router = router
    }

    func handleDeepLink(_ url: URL) {
        guard let host = url.host else {
            return
        }

        switch host {
        case "example.com":
            handleExampleDeepLink(url)
        case "anotherlink.com":
            handleAnotherExampleLinkDeepLink(url)
        default:
            showDefaultView()
        }
    }

    private func handleExampleDeepLink(_ url: URL) {
        //let parameters = url.queryParameters
        // let productID = parameters["productID"]
        // navigateToProductDetail(productID)
    }

    private func handleAnotherExampleLinkDeepLink(_ url: URL) {
        //let parameters = url.queryParameters
        // let articleID = parameters["articleID"]
        // navigateToArticleDetail(articleID)
    }

    private func showDefaultView() {

    }
}


