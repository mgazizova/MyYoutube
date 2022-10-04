//
//  VideoTitleCell.swift
//  MyYoutube
//
//  Created by Мария Газизова on 15.08.2022.
//

import UIKit

class VideoTitleCell: UITableViewCell {
    static let reuseId = "videoTitleCell"
    private let titleLabel = UILabel()

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
        self.contentView.addSubview(titleLabel)
    }

    private func setConstrains() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 16),
            titleLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 16),
            titleLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -16),
            titleLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])
    }

    private func configureSubviews() {
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont(name: "AppleSDGothicNeo-Light", size: 20)
    }

    func configure(with video: Video) {
        titleLabel.text = video.getTitle()
    }
}
