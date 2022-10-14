//
//  RatingModel.swift
//  MyYoutube
//
//  Created by Мария Газизова on 14.10.2022.
//

import Foundation

struct RatingModel: Decodable {
    let kind: String
    let etag: String
    let items: [RatingItem]?
}

struct RatingItem: Decodable {
    let videoId: String
    let rating: Rate
}

extension RatingModel {
    func getRating(by index: Int) -> Rate? {
        guard let items = items else { return nil }
        return items[index].rating
    }
}
