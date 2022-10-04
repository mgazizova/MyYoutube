//
//  CustomError.swift
//  MyYoutube
//
//  Created by Мария Газизова on 25.07.2022.
//
import Foundation

enum CustomError {
    case wrongURL
    case invalidChannelId
    case invalidLocation
    case invalidRelevanceLanguage
    case invalidSearchFilter
    case invalidVideoId
}

extension CustomError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .wrongURL:
            return "There is wrong URL."
        case .invalidChannelId:
            return "The channelId parameter specified an invalid channel ID."
        case.invalidLocation:
            return "The location and/or locationRadius parameter value was formatted incorrectly."
        case .invalidRelevanceLanguage:
            return "The relevanceLanguage parameter value was formatted incorrectly."
        case .invalidSearchFilter:
            return "The request contains an invalid combination of search filters and/or restrictions."
        case .invalidVideoId:
            return "The relatedToVideo parameter specified an invalid video ID."
        }
    }
}
