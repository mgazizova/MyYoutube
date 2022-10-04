//
//  ActionButton.swift
//  MyYoutube
//
//  Created by Мария Газизова on 16.08.2022.
//

import UIKit

class ActionButton: UIButton {

    private var label = UILabel()
    private var icon = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubviews()
        configureButton()
        setConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        configureButton()
    }

    private func addSubviews() {
        addSubview(icon)
        addSubview(label)
    }

    private func configureButton() {
        backgroundColor = .white
        layer.cornerRadius = 30

        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 60),
            widthAnchor.constraint(equalToConstant: 60)
        ])

        label.font = UIFont(name: "AppleSDGothicNeo-Light", size: 14)
        label.textAlignment = .center
    }

    private func setConstraints() {
        icon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            icon.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            icon.topAnchor.constraint(equalTo: self.topAnchor),
            icon.heightAnchor.constraint(equalToConstant: 40),
            icon.widthAnchor.constraint(equalToConstant: 40)
        ])

        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            label.topAnchor.constraint(equalTo: icon.bottomAnchor, constant: 5),
            label.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8),
            label.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }

    func setContent(image: UIImage?, text: String?) {
        if let image = image {
            icon.image = image
            icon.tintColor = .black
        }

        if let text = text {
            label.text = text
        }
    }
}
