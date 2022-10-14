//
//  VideoTableViewCell.swift
//  MyYoutube
//
//  Created by Мария Газизова on 24.07.2022.
//

import UIKit
import Kingfisher

class VideoTableViewCell: UITableViewCell {

    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let channelImageView = UIImageView()
    private let thumbnailImage = UIImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        setConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubviews() {
        contentView.addSubview(channelImageView)
        contentView.addSubview(thumbnailImage)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
    }

    private func setConstraints() {
        thumbnailImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            thumbnailImage.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 16),
            thumbnailImage.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 16),
            thumbnailImage.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -16),
            // TODO: How does it work?
            thumbnailImage.heightAnchor.constraint(equalToConstant: self.contentView.frame.width * 9 / 16)
        ])

        channelImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            channelImageView.topAnchor.constraint(equalTo: thumbnailImage.bottomAnchor, constant: 8),
            channelImageView.leftAnchor.constraint(equalTo: thumbnailImage.leftAnchor),
            channelImageView.widthAnchor.constraint(equalToConstant: 40),
            channelImageView.heightAnchor.constraint(equalToConstant: 40),
            channelImageView.bottomAnchor.constraint(equalTo: channelImageView.topAnchor, constant: -8)
        ])
        channelImageView.layer.cornerRadius = 20
        channelImageView.clipsToBounds = true

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: thumbnailImage.bottomAnchor, constant: 8),
            titleLabel.leftAnchor.constraint(equalTo: channelImageView.rightAnchor, constant: 8),
            titleLabel.rightAnchor.constraint(equalTo: thumbnailImage.rightAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 20)
        ])

        titleLabel.font = UIFont(name: "AppleSDGothicNeo-Light", size: 14)

        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            descriptionLabel.leftAnchor.constraint(equalTo: channelImageView.rightAnchor, constant: 8),
            descriptionLabel.rightAnchor.constraint(equalTo: thumbnailImage.rightAnchor),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 20),
            descriptionLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8)
        ])
        descriptionLabel.textColor = .gray
        descriptionLabel.font = UIFont(name: "AppleSDGothicNeo-Light", size: 14)
    }

    public func setVideoCell(withTitle title: String?,
                             furtherInfo: String?,
                             channelImage: URL?,
                             previewImage previewUrl: URL?) {
        if let title = title {
            titleLabel.text = title
        }

        if let description = furtherInfo {
            descriptionLabel.text = description
        }

        if let url = channelImage {
            channelImageView.kf.setImage(with: url)
        }

        if let url = previewUrl {
            thumbnailImage.kf.setImage(with: url)
        }
    }
}
