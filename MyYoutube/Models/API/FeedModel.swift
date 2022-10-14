//
//  FeedModel.swift
//  MyYoutube
//
//  Created by Мария Газизова on 25.07.2022.
//
import Foundation

struct FeedModel: Decodable {
    let items: [VideoItemModel]?
    let regionCode: String?
    let nextPageToken: String?
    let prevPageToken: String?
    let error: ErrorModel?
}

struct VideoItemModel: Decodable {
    let etag: String
    let kind: String
    let id: String
    let snippet: VideoSnippetModel
    let statistics: VideoStatisticsModel
}

struct VideoSnippetModel: Decodable {
    let title: String
    let description: String
    let channelId: String
    let channelTitle: String
    let publishedAt: String
    let thumbnails: ThumbnailsModel
}

struct VideoStatisticsModel: Decodable {
    let viewCount: String
    let likeCount: String?
    let commentCount: String?
}

extension FeedModel {
    func getVideoTitle(withIndex: Int) -> String? {
        guard let items = items else { return nil }
        return items[withIndex].getTitle()
    }

    func getVideoDescription(withIndex: Int) -> String? {
        guard let items = items else { return nil }
        return items[withIndex].getDescription()
    }

    func getHighPreviewUrl(withIndex: Int) -> URL? {
        guard let items = items else { return nil }
        return items[withIndex].getHighThumbnail()
    }

    func getMediumPreviewUrl(withIndex: Int) -> URL? {
        guard let items = items else { return nil }
        return items[withIndex].getMediumThumbnail()
    }

    func getNextPageToken() -> String? {
        return nextPageToken
    }

    func getPreviousPageToken() -> String? {
        return prevPageToken
    }
}

extension VideoItemModel {
    func getId() -> String {
        return id
    }

    func getTitle() -> String {
        return snippet.title
    }

    func getDescription() -> String {
        return snippet.description
    }

    func getMediumThumbnail() -> URL {
        return snippet.thumbnails.medium.url
    }

    func getHighThumbnail() -> URL {
        return snippet.thumbnails.high.url
    }

    func getChannelId() -> String {
        return snippet.channelId
    }

    func getChannelName() -> String {
        return snippet.channelTitle
    }

    func getPublishedDate() -> String {
        return snippet.publishedAt
    }

    func getViewCount() -> String {
        return statistics.viewCount
    }

    func getLikeCount() -> String {
        return statistics.likeCount ?? "0"
    }

    func getCommentCount() -> String? {
        return statistics.commentCount
    }
}
