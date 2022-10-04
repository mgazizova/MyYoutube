//
//  VideoSubtitleCell.swift
//  MyYoutube
//
//  Created by Мария Газизова on 15.08.2022.
//

import UIKit

class VideoSubtitleCell: UITableViewCell {
    static let reuseId = "videoSubtitleCell"
    private let subTitleLabel = UILabel()

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
        self.contentView.addSubview(subTitleLabel)
    }

    private func setConstrains() {
        subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subTitleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8),
            subTitleLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 16),
            subTitleLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -16),
            subTitleLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])
    }

    private func configureSubviews() {
        subTitleLabel.textColor = .gray
        subTitleLabel.font = UIFont(name: "AppleSDGothicNeo-Light", size: 14)
    }

    func configure(with video: Video) {
        subTitleLabel.text = video.getViewCount().appendWithDot(strings: video.getPublishedDate())
    }
}
