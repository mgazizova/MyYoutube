//
//  TitleView.swift
//  MyYoutube
//
//  Created by Мария Газизова on 16.09.2022.
//

import UIKit

class TitleView: UIView {

    let titleLabel = UILabel()
    let signButton = SignInButton()
    var didSignInButtonTapped: (() -> Void)?

    override var intrinsicContentSize: CGSize {
      return UIView.layoutFittingExpandedSize
    }

    func configure(with title: String) {
        addSubviews()
        setConstraints()
        configureSubviews()

        titleLabel.text = title
    }

    private func addSubviews() {
        addSubview(titleLabel)
        addSubview(signButton)
    }

    private func setConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        signButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        NSLayoutConstraint.activate([
            signButton.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            signButton.topAnchor.constraint(equalTo: topAnchor),
            signButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            signButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        ])
    }

    private func configureSubviews() {
        titleLabel.textColor = .white
        titleLabel.font = UIFont(name: "AppleSDGothicNeo-Light", size: 24)

        signButton.addTarget(self, action: #selector(tapSignIn), for: .touchUpInside)
    }

    @objc func tapSignIn() {
        if let didSignInButtonTapped = didSignInButtonTapped {
            didSignInButtonTapped()
        }
    }

    func changesWhenSignIn() {
        signButton.setSignOutIcon()
    }

    func changesWhenSignOut() {
        signButton.setSignInIcon()
    }
}
