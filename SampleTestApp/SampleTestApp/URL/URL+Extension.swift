//
//  URL+Extension.swift
//  SampleTestApp
//
//  Created by Omeir on 16/09/2023.
//

import Foundation

extension URL {
    var queryParameters: [String: String] {
        var parameters = [String: String]()
        if let components = URLComponents(url: self, resolvingAgainstBaseURL: false),
            let queryItems = components.queryItems {
            queryItems.forEach { parameters[$0.name] = $0.value }
        }
        return parameters
    }
}
