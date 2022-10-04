//
//  ChannelModel.swift
//  MyYoutube
//
//  Created by Мария Газизова on 27.07.2022.
//

import Foundation

struct ChannelsModel: Decodable {
    let etag: String
    let kind: String
    let items: [ChannelItemModel]?
    let error: ErrorModel?

    func getMediumPreviewUrl(withIndex: Int) -> URL? {
        guard let items = items else { return nil }
        return items[withIndex].getMediumPreview()
    }

    func getHighPreviewUrl(withIndex: Int) -> URL? {
        guard let items = items else { return nil }
        return items[withIndex].getHighPreview()
    }
}

struct ChannelItemModel: Decodable {
    let id: String
    let snippet: ChannelSnippetModel

    func getId() -> String {
        return id
    }

    func getMediumPreview() -> URL {
        return snippet.thumbnails.medium.url
    }

    func getHighPreview() -> URL {
        return snippet.thumbnails.high.url
    }
}

struct ChannelSnippetModel: Decodable {
    let title: String
    let description: String
    let thumbnails: ThumbnailsModel
}
