//
//  ActionsCell.swift
//  MyYoutube
//
//  Created by Мария Газизова on 15.08.2022.
//

import UIKit
import SwiftUI

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

class ActionsCell: UITableViewCell {
    static let reuseId = "actionsCell"

    private var likeButton: ActionButton?
    private var dislikeButton: ActionButton?
    private var shareButton: ActionButton?

    private var liked = false
    private var disliked = false

    var actionExecutor: ActionDelegate?

    var video: Video?

    private let actionsStackView = UIStackView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none

        addSubviews()
        setConstrains()
        configureSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubviews() {
        self.contentView.addSubview(actionsStackView)
    }

    private func setConstrains() {
        actionsStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            actionsStackView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            actionsStackView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 32),
            actionsStackView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -32),
            actionsStackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])
    }

    private func configureSubviews() {
        actionsStackView.backgroundColor = .white
        actionsStackView.axis = .horizontal
        actionsStackView.distribution = .equalSpacing
    }

    private func configureActionButtons() {
        likeButton = ActionButton()
        if let video = video {
            likeButton?.setContent(image: Action.like.getIcon(),
                                   text: video.getLikeCount().mixedRepresentation())
        }

        dislikeButton = ActionButton()
        dislikeButton?.setContent(image: Action.dislike.getIcon(), text: Action.dislike.getName())

        shareButton = ActionButton()
        shareButton?.setContent(image: Action.share.getIcon(), text: Action.share.getName())

        actionsStackView.addArrangedSubview(likeButton!)
        actionsStackView.addArrangedSubview(dislikeButton!)
        actionsStackView.addArrangedSubview(shareButton!)

        likeButton?.addTarget(self, action: #selector(tapLike), for: .touchUpInside)
        dislikeButton?.addTarget(self, action: #selector(tapDislike), for: .touchUpInside)
        shareButton?.addTarget(self, action: #selector(tapShare), for: .touchUpInside)
    }

    private func sendAction(_ action: Action) {
        actionExecutor?.execute(action: action)
    }

    @objc func tapLike() {
        guard let video = video else { return }

        if liked {
            sendAction(Action.nonReaction)
            likeButton?.setContent(image: Action.like.getIcon(), text: video.getLikeCount().mixedRepresentation())
        } else {
            sendAction(Action.like)
            likeButton?.setContent(image: Action.like.getTappedIcon(),
                                   text: (video.getLikeCount() + 1).mixedRepresentation())
            dislikeButton?.setContent(image: Action.dislike.getIcon(), text: Action.dislike.getName())
        }
        liked = !liked
        disliked = false
    }

    @objc func tapDislike() {
        guard let video = video else { return }

        if disliked {
            sendAction(Action.nonReaction)
            dislikeButton?.setContent(image: Action.dislike.getIcon(), text: Action.dislike.getName())
        } else {
            sendAction(Action.dislike)
            dislikeButton?.setContent(image: Action.dislike.getTappedIcon(), text: Action.dislike.getName())
            likeButton?.setContent(image: Action.like.getIcon(), text: video.getLikeCount().mixedRepresentation())
        }
        disliked = !disliked
        liked = false
    }

    @objc func tapShare() {
        sendAction(Action.nonReaction)
    }

    func configure(with video: Video) {
        self.video = video
        configureActionButtons()
    }
}
