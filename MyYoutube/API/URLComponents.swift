//
//  URLComponents.swift
//  MyYoutube
//
//  Created by Мария Газизова on 25.07.2022.
//

import Foundation
import WebKit

protocol URLCustomComponents {
    var baseURL: String { get }
    var path: String { get }
    var params: [(String, String)] { get }
    var fullURL: URL? { get }
}

extension URLCustomComponents {
    var fullURL: URL? {
        guard let url = URL(string: baseURL) else { return nil }

        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.path = path
        components?.setQueryItems(with: params)
        return components?.url
    }
}

extension URLComponents {
    mutating func setQueryItems(with parameters: [(String, String)]) {
        self.queryItems = parameters.map { URLQueryItem(name: $0.0, value: $0.1) }
    }
}
