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
            actionsCell.configure(with: video)
            return actionsCell
        default: fatalError()
        }
    }
}

extension VideoViewController: ActionDelegate {
    func execute(action: Action) {

        guard let video = video else { return }
        switch action {
        case .like:
            youTubeManager.rate(video: video.getId(), with: Rate.like) { [weak self] result in
                self?.handleRateResult(result: result)
            }
        case .dislike:
            youTubeManager.rate(video: video.getId(), with: Rate.dislike) { [weak self] result in
                self?.handleRateResult(result: result)
            }
        case .nonReaction:
            youTubeManager.rate(video: video.getId(), with: Rate.none) { [weak self] result in
                 self?.handleRateResult(result: result)
            }
        case .share:
            guard let link = YouTubeEndPoint.watchVideo(videoId: video.getId()).fullURL else { return }

            let activityViewController = UIActivityViewController(activityItems: [link], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            present(activityViewController, animated: true, completion: nil)
        }
    }
}

extension VideoViewController {
    private func showAlert(withError: CustomError) {
        let alert = UIAlertController(title: "Error", message: withError.errorDescription, preferredStyle: .alert)
        // swiftlint:disable todo
        // TODO: do alert well
        // swiftlint:enable todo
        // TODO: another todo without ignore
    }

    private func handleRateResult(result: Result<Data?, CustomError>) {
        switch result {
        case .success(_):
            break
        case .failure(let error):
            showAlert(withError: error)
        }
    }
}
