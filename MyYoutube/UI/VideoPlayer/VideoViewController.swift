//
//  VideoViewController.swift
//  MyYoutube
//
//  Created by Мария Газизова on 14.08.2022.
//
import youtube_ios_player_helper
import UIKit
import GoogleSignIn

protocol ActionDelegate {
    func execute(action: Action)
}

class VideoViewController: UIViewController, UITableViewDelegate {

    var video: Video?
    private let tableView = UITableView()
    private let youTubeManager = YouTubeApiManager()

    var liked = false
    var disliked = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white

        addSubviews()
        configure()
        setConstraints()
        configureSubviews()
    }

    private func addSubviews() {
        self.view.addSubview(tableView)
    }

    private func configure() {
        tableView.dataSource = self
        tableView.delegate = self

        youTubeManager.shouldAuthorize = { authorizeCompletion in
            AuthenticationService.shared.authenticate(presenting: self) { [weak self] result in
                switch result {
                case .success(_):
                    authorizeCompletion(.success(nil))
                case .failure(let error):
                    authorizeCompletion(.failure(error))
                }
            }
        }

        if let user = AuthenticationService.shared.user, let video = video {
            youTubeManager.getRating(video: video.getId()) { [weak self] result in
                switch result {
                case .success(let rate):
                    switch rate {
                    case .like:
                        self?.liked = true
                        self?.disliked = false
                        self?.reloadActionBar()
                    case .dislike:
                        self?.liked = false
                        self?.disliked = false
                        self?.reloadActionBar()
                    case .none:
                        self?.liked = false
                        self?.disliked = false
                    }
                case .failure(let error):
                    break
                }
            }
        }
    }

    private func setConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }

    private func configureSubviews() {
        tableView.register(VideoPlayerCell.self, forCellReuseIdentifier: VideoPlayerCell.reuseId)
        tableView.register(VideoTitleCell.self, forCellReuseIdentifier: VideoTitleCell.reuseId)
        tableView.register(VideoSubtitleCell.self, forCellReuseIdentifier: VideoSubtitleCell.reuseId)
        tableView.register(ActionsCell.self, forCellReuseIdentifier: ActionsCell.reuseId)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
    }
}

extension VideoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let video = video else { return UITableViewCell() }
        switch indexPath.row {
        case 0:
            guard let videoPlayerCell = tableView.dequeueReusableCell(
                withIdentifier: VideoPlayerCell.reuseId,
                for: indexPath) as? VideoPlayerCell else {
                    return UITableViewCell()
                }
            videoPlayerCell.configure(with: video)
            return videoPlayerCell
        case 1:
            guard let videoTitleCell = tableView.dequeueReusableCell(
                withIdentifier: VideoTitleCell.reuseId,
                for: indexPath) as? VideoTitleCell else {
                    return UITableViewCell()
                }
            videoTitleCell.configure(with: video)
            return videoTitleCell
        case 2:
            guard let videoSubTitleCell = tableView.dequeueReusableCell(
                withIdentifier: VideoSubtitleCell.reuseId,
                for: indexPath) as? VideoSubtitleCell else {
                    return UITableViewCell()
                }
            videoSubTitleCell.configure(with: video)
            return videoSubTitleCell
        case 3:
            guard let actionsCell = tableView.dequeueReusableCell(
                withIdentifier: ActionsCell.reuseId,
                for: indexPath) as? ActionsCell else {
                    return UITableViewCell()
                }
            actionsCell.actionExecutor = self
            actionsCell.configure(with: video.getLikeCount(), liked: liked, disliked: disliked)
            return actionsCell
        default: fatalError()
        }
    }

    func reloadActionBar() {
        let indexPath = IndexPath(row: 3, section: 0)
        DispatchQueue.main.async {
            self.tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
}

extension VideoViewController: ActionDelegate {
    func execute(action: Action) {
        guard let video = video else { return }
        switch action {
        case .like:
            if liked {
                execute(action: Action.nonReaction)
                return
            }
            youTubeManager.rate(video: video.getId(), with: Rate.like) { [weak self] result in
                switch result {
                case .success(_):
                    self?.liked = true
                    self?.disliked = false
                    self?.reloadActionBar()
                case .failure(let error):
                    break
                }}
        case .dislike:
            if disliked {
                execute(action: Action.nonReaction)
                return
            }
            youTubeManager.rate(video: video.getId(), with: Rate.dislike) { [weak self] result in
                switch result {
                case .success(_):
                    self?.liked = false
                    self?.disliked = true
                    self?.reloadActionBar()
                case .failure(let error):
                    break
                }}
        case .nonReaction:
            youTubeManager.rate(video: video.getId(), with: Rate.none) { [weak self] result in
                switch result {
                case .success(_):
                    self?.liked = false
                    self?.disliked = false
                    self?.reloadActionBar()
                case .failure(let error):
                    break
                }
            }
        case .share:
            guard let link = YouTubeEndPoint.watchVideo(videoId: video.getId()).fullURL else { return }

            let activityViewController = UIActivityViewController(activityItems: [link], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            present(activityViewController, animated: true, completion: nil)
        }
    }
}
