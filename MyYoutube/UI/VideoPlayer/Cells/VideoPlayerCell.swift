//
//  VideoPlayerCell.swift
//  MyYoutube
//
//  Created by Мария Газизова on 15.08.2022.
//

import UIKit
import youtube_ios_player_helper

class VideoPlayerCell: UITableViewCell, YTPlayerViewDelegate {
    static let reuseId = "videoPlayerCell"
    private let playerView = YTPlayerView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .red
        self.selectionStyle = .none

        addSubviews()
        setConstraints()
        configureSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubviews() {
        self.contentView.addSubview(playerView)
    }

    private func setConstraints() {
        playerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            playerView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            playerView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor),
            playerView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor),
            playerView.heightAnchor.constraint(equalToConstant: (self.frame.width + 54) * 9 / 16),
            playerView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])
    }

    private func configureSubviews() {
        playerView.delegate = self
    }

    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        playerView.playVideo()
    }

    func configure(with video: Video) {
        playerView.load(withVideoId: video.getId())
    }
}
