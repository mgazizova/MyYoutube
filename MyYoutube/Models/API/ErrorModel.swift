//
//  ErrorModel.swift
//  MyYoutube
//
//  Created by Мария Газизова on 27.07.2022.
//

import Foundation

struct ErrorModel: Decodable {
    let code: Int
    let message: String
    let errors: [ErrorDescriptionModel]
}

struct ErrorDescriptionModel: Decodable {
    let domain: String
    let reason: String
    let locationType: String
}
