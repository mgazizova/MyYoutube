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
enum Rate {
    case like
    case dislike
    case none

    func getName() -> String {
        switch self {
        case .like:
            return "like"
        case .dislike:
            return "dislike"
        case .none:
            return "none"
        }
    }
}

enum YouTubeEndPoint {
    case feedListWithSnippets(accessKey: String, pageToken: String?)
    case channelInfoSnippet(accessKey: String, channelsIds: [String])
    case watchVideo(videoId: String)
    case rateVideo(videoId: String, rate: Rate)
}

extension YouTubeEndPoint: URLCustomComponents {

    var baseURL: String {
        switch self {
        case .feedListWithSnippets, .channelInfoSnippet:
            return "https://youtube.googleapis.com"
        case .watchVideo:
            return "https://www.youtube.com"
        case .rateVideo:
            return "https://www.googleapis.com"
        }
    }

    var path: String {
        switch self {
        case .feedListWithSnippets:
            return "/youtube/v3/videos"
        case .channelInfoSnippet:
            return "/youtube/v3/channels"
        case .watchVideo:
            return "/watch"
        case .rateVideo:
            return "/youtube/v3/videos/rate"
        }
    }

    var params: [(String, String)] {
        switch self {
        case let .feedListWithSnippets(accessKey, pageToken):
            return [
                ("part", "snippet,statistics"),
                ("key", accessKey),
                ("chart", "mostPopular"),
                ("pageToken", pageToken ?? "")
            ]

        case let .channelInfoSnippet(accessKey, channelsIds):
            let idArray = [String](repeating: "id", count: channelsIds.count)
            let  repeatedParams = Array(zip(idArray, channelsIds))

            var params = [
                ("part", "snippet"),
                ("key", "\(accessKey)")
            ]
            params.append(contentsOf: repeatedParams)
            return params

        case let .watchVideo(videoId):
            return [
                ("v", videoId)
            ]
        case let .rateVideo(videoId, rate):
            return [
                ("id", videoId),
                ("rating", rate.getName())
            ]
        }
    }
}
