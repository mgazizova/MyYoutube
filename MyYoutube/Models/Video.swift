//
//  Video.swift
//  MyYoutube
//
//  Created by Мария Газизова on 24.07.2022.
//

import Foundation

class Video {

    private let id: String
    private let title: String
    private let description: String
    private let thumbnail: URL
    private let channel: Channel
    private let viewCount: Int
    private let likeCount: Int
    private let publishedDate: String

    init(from model: VideoItemModel) {
        self.id = model.getId()
        self.title = model.getTitle()
        self.description = model.getDescription()
        self.thumbnail = model.getMediumThumbnail()
        self.publishedDate = model.getPublishedDate()
        channel = Channel(id: model.getChannelId(), name: model.getChannelName(), preview: nil)
        self.viewCount = Int(model.getViewCount()) ?? 0
        self.likeCount = Int(model.getLikeCount()) ?? 0
    }

    func getId() -> String { return id }

    func getTitle() -> String { return title }

    func getDescription() -> String { return description }

    func getThumbnail() -> URL { return thumbnail }

    func getChannelId() -> String { return channel.id }

    func getChannelName() -> String { return channel.name }

    func getChannelPreview() -> URL? { return channel.preview }

    func getViewCount() -> Int { return viewCount }

    func getViewCount() -> String {
        return viewCount.mixedRepresentation() + " views"
    }

    func getLikeCount() -> Int {
        return likeCount
    }

    func getPublishedDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"

        return dateFormatter.date(from: publishedDate)
    }

    func getPublishedDate() -> String {
        guard let date = getPublishedDate() else { return "" }
        return date.timeAgoDisplay()
    }

    func getFurtherInfo() -> String {
        return channel.name.appendWithDot(strings: getViewCount(), getPublishedDate())
    }

    func setChannelPreview(with channelPreview: URL) {
        channel.setPreview(with: channelPreview)
    }
}

extension Int {
    func mixedRepresentation() -> String {
        if self < 999 {
            return "\(String(self))"
        }
        if self < 999999 {
            let value = Double(self) / 1000
            return String(format: "%.1fK", value)
        }
        if self < 999999999 {
            let value = Double(self) / 1000000
            return String(format: "%.1fM", value)
        }
        let value = Double(self) / 1000000000
        return String(format: "%.1fB", value)
    }
}

extension String {
    func appendWithDot(strings: String...) -> String {
        var result = self
        for str in strings {
            result.append(contentsOf: " • \(str)")
        }

        return result
    }
}

extension Date {
    func timeAgoDisplay() -> String {
        let calendar = Calendar.current
        let minuteAgo = calendar.date(byAdding: .minute, value: -1, to: Date())!
        let hourAgo = calendar.date(byAdding: .hour, value: -1, to: Date())!
        let dayAgo = calendar.date(byAdding: .day, value: -1, to: Date())!
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: Date())!
        let monthAgo = calendar.date(byAdding: .month, value: -1, to: Date())!
        let yearAgo = calendar.date(byAdding: .year, value: -1, to: Date())!

        if minuteAgo < self {
            let diff = Calendar.current.dateComponents([.second], from: self, to: Date()).second ?? 0
            return "\(diff) sec ago"
        }
        if hourAgo < self {
            let diff = Calendar.current.dateComponents([.minute], from: self, to: Date()).minute ?? 0
            return diff == 1 ? "\(diff) minute ago" : "\(diff) minutes ago"
        }
        if dayAgo < self {
            let diff = Calendar.current.dateComponents([.hour], from: self, to: Date()).hour ?? 0
            return diff == 1 ? "\(diff) hour ago" : "\(diff) hours ago"
        }
        if weekAgo < self {
            let diff = Calendar.current.dateComponents([.day], from: self, to: Date()).day ?? 0
            return diff == 1 ? "\(diff) day ago" : "\(diff) days ago"
        }
        if monthAgo < self {
            let diff = Calendar.current.dateComponents([.weekOfMonth], from: self, to: Date()).weekOfMonth ?? 0
            return diff == 1 ? "\(diff) week ago" : "\(diff) weeks ago"
        }
        if yearAgo < self {
            let diff = Calendar.current.dateComponents([.month], from: self, to: Date()).month ?? 0
            return diff == 1 ? "\(diff) month ago" : "\(diff) months ago"
        }
        let diff = Calendar.current.dateComponents([.year], from: self, to: Date()).year ?? 0
        return diff == 1 ? "\(diff) year ago" : "\(diff) years ago"
    }
}
