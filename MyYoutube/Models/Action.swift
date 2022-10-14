//
//  Action.swift
//  MyYoutube
//
//  Created by Мария Газизова on 14.10.2022.
//

import UIKit

enum Action {
    case like
    case dislike
    case nonReaction
    case share

    func getName() -> String {
        switch self {
        case .like:
            return "Like"
        case .dislike:
            return "Dislike"
        case .nonReaction:
            return "nonReaction"
        case .share:
            return "Share"
        }
    }

    func getIcon() -> UIImage? {
        switch self {
        case .like:
            return UIImage(named: "like.png")
        case .dislike:
            return UIImage(named: "dislike.png")
        case .nonReaction:
            return nil
        case .share:
            return UIImage(named: "share.png")
        }
    }

    func getTappedIcon() -> UIImage? {
        switch self {
        case .like:
            return UIImage(named: "like_filled.png")
        case .dislike:
            return UIImage(named: "dislike_filled.png")
        case .nonReaction:
            return nil
        case .share:
            return UIImage(named: "share.png")
        }
    }
}
