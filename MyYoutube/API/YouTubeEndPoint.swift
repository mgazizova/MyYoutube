//
//  YouTubeEndPoint.swift
//  MyYoutube
//
//  Created by Мария Газизова on 14.10.2022.
//

import Foundation

enum YouTubeEndPoint {
    case feedListWithSnippets(accessKey: String, pageToken: String?)
    case channelInfoSnippet(accessKey: String, channelsIds: [String])
    case watchVideo(videoId: String)
    case rateVideo(videoId: String, rate: Rate)
    case getRating(videoId: String)
}

extension YouTubeEndPoint: URLCustomComponents {

    var baseURL: String {
        switch self {
        case .feedListWithSnippets, .channelInfoSnippet:
            return "https://youtube.googleapis.com"
        case .watchVideo:
            return "https://www.youtube.com"
        case .rateVideo, .getRating:
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
        case .getRating:
            return "/youtube/v3/videos/getRating"
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
                ("rating", rate.rawValue)
            ]

        case let .getRating(videoId):
            return [
                ("id", videoId)
            ]
        }
    }
}
