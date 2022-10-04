//
//  ThumbnailsModel.swift
//  MyYoutube
//
//  Created by Мария Газизова on 27.07.2022.
//

import Foundation

struct ThumbnailsModel: Decodable {
    let medium: PreviewModel
    let high: PreviewModel
}

struct PreviewModel: Decodable {
    let url: URL
    let width: Int
    let height: Int
}
