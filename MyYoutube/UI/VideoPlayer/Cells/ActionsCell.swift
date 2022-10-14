//
//  ActionsCell.swift
//  MyYoutube
//
//  Created by Мария Газизова on 15.08.2022.
//

import UIKit

class ActionsCell: UITableViewCell {
    static let reuseId = "actionsCell"

    private let actionsStackView = UIStackView()

    private var likeButton = ActionButton()
    private var dislikeButton = ActionButton()
    private var shareButton = ActionButton()

    var actionExecutor: ActionDelegate?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none

        addSubviews()
        setConstrains()
        configure()
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

    private func sendAction(_ action: Action) {
        actionExecutor?.execute(action: action)
    }

    func configure() {
        clearLike(with: 0)
        clearDislike()
        shareButton.setContent(image: Action.share.getIcon(), text: Action.share.getName())

        actionsStackView.addArrangedSubview(likeButton)
        actionsStackView.addArrangedSubview(dislikeButton)
        actionsStackView.addArrangedSubview(shareButton)

        likeButton.addTarget(self, action: #selector(tapLike), for: .touchUpInside)
        dislikeButton.addTarget(self, action: #selector(tapDislike), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(tapShare), for: .touchUpInside)
    }

    func configure(with likeCount: Int, liked: Bool, disliked: Bool) {
        if liked {
            clearDislike()
            fillLike(with: likeCount)
            return
        }
        if disliked {
            clearLike(with: likeCount)
            fillDislike(with: likeCount)
            return
        }
        clearLike(with: likeCount)
        clearDislike()
    }

    @objc func tapLike() {
        sendAction(Action.like)
    }

    @objc func tapDislike() {
        sendAction(Action.dislike)
    }

    @objc func tapShare() {
        sendAction(Action.share)
    }
}

extension ActionsCell {
    func fillLike(with likeCount: Int) {
        likeButton.setContent(image: Action.like.getTappedIcon(),
                               text: likeCount.mixedRepresentation())
        dislikeButton.setContent(image: Action.dislike.getIcon(), text: Action.dislike.getName())
    }

    func fillDislike(with likeCount: Int) {
        dislikeButton.setContent(image: Action.dislike.getTappedIcon(), text: Action.dislike.getName())
        likeButton.setContent(image: Action.like.getIcon(), text: likeCount.mixedRepresentation())
    }

    func clearLike(with likeCount: Int) {
        likeButton.setContent(image: Action.like.getIcon(), text: likeCount.mixedRepresentation())
    }

    func clearDislike() {
        dislikeButton.setContent(image: Action.dislike.getIcon(), text: Action.dislike.getName())
    }
}
