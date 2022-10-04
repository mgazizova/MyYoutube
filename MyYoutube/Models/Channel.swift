//
//  Channel.swift
//  MyYoutube
//
//  Created by Мария Газизова on 15.08.2022.
//

import Foundation

class Channel {
    let id: String
    let name: String
    var preview: URL?

    init(id: String, name: String, preview: URL?) {
        self.id = id
        self.name = name
        if let channelPreview = preview { self.preview = channelPreview }
    }

    func setPreview(with preview: URL) {
        self.preview = preview
    }
}
