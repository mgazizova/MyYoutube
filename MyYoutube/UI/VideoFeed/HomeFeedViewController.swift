//
//  ViewController.swift
//  MyYoutube
//
//  Created by Мария Газизова on 24.07.2022.
//

import UIKit
import GoogleSignIn
import SwiftUI

class HomeFeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private let tableView = UITableView()
    private let tableCellId = "videoCellId"
    private let youTubeManager = YouTubeApiManager()
    private var feed: FeedModel?
    private var videos: [Video] = []
    private var nextPageToken: String?
    private var activityIndicator = UIActivityIndicatorView()
    private var isDataLoading = false

    override func viewDidLoad() {
        super.viewDidLoad()

        addSubviews()
        setConstraints()
        configureSubviews()

        youTubeManager.fetchFeedItems(pageToken: nextPageToken) { [weak self] result in
            self?.handleFeedResult(result: result)
        }
    }

    private func showAlert(withError: CustomError) {
        let alert = UIAlertController(title: "Error", message: withError.errorDescription, preferredStyle: .alert)
        //TODO: do alert well
    }
}

extension HomeFeedViewController {
    private func handleFeedResult(result: Result<FeedModel, CustomError>) {
        switch result {
        case .success(let feedVideoItems):
            feed = feedVideoItems

            guard let feed = feed, let items = feed.items else { return }
            for video in items {
                videos.append(Video(from: video))
            }

            nextPageToken = feed.getNextPageToken()

            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.stopActivityIndicator()
            }

            if let items = feed.items {
                let channelsIds = items.map({ $0.getChannelId() })
                youTubeManager.fetchChannelsItems(channelsIds: channelsIds) { [weak self] result in
                    self?.handleChannelsResult(result: result)
                }
            }
        case .failure(let error):
            showAlert(withError: error)
        }
    }

    private func handleChannelsResult(result: Result<ChannelsModel, CustomError>) {
        switch result {
        case .success(let channelItems):
            guard let items = channelItems.items else { return }

            var channelPreview: [String: URL] = [:]
            for item in items {
                channelPreview[item.getId()] = item.getMediumPreview()
            }

            for video in videos {
                if let url = channelPreview[video.getChannelId()] {
                    video.setChannelPreview(with: url)
                }
            }

            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        case .failure(let error):
            showAlert(withError: error)
        }
    }
}

extension HomeFeedViewController {
    private func addSubviews() {
        view.addSubview(tableView)
    }

    private func setConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
        tableView.separatorStyle = .none
    }

    private func configureSubviews() {
        configureTableView()
        configureNavigationBar()
    }

    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self

        tableView.register(VideoTableViewCell.self, forCellReuseIdentifier: tableCellId)

        activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.frame = CGRect(x: CGFloat(0),
                                         y: CGFloat(20),
                                         width: tableView.bounds.width,
                                         height: CGFloat(32))
        activityIndicator.hidesWhenStopped = true
        startActivityIndicator()
        tableView.tableFooterView = activityIndicator
    }

    private func configureNavigationBar() {
        let titleView = TitleView()
        titleView.configure(with: "Home")

        navigationItem.titleView = titleView

        navigationController?.navigationBar.backgroundColor = .red
        navigationController?.navigationBar.barTintColor = .red
        navigationController?.navigationBar.tintColor = .white

        titleView.didSignInButtonTapped = { () -> Void in
            AuthenticationService.shared.authenticate(presenting: self) { [weak self] result in
                switch result {
                case .success(_):
                    titleView.changesWhenSignIn()
                case .failure(let error):
                    self?.showAlert(withError: error)
                }
            }
        }
    }
}

extension HomeFeedViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: tableCellId,
                                                       for: indexPath) as? VideoTableViewCell else {
            return UITableViewCell()
        }

        cell.setVideoCell(withTitle: videos[indexPath.row].getTitle(),
                          furtherInfo: videos[indexPath.row].getFurtherInfo(),
                          channelImage: videos[indexPath.row].getChannelPreview(),
                          previewImage: videos[indexPath.row].getThumbnail())
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let videoVC = VideoViewController()
        videoVC.video = videos[indexPath.row]

        navigationController?.pushViewController(videoVC, animated: true)
    }
}

extension HomeFeedViewController {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isDataLoading = false
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if tableView.contentOffset.y + tableView.frame.size.height >= tableView.contentSize.height, !isDataLoading {
            startActivityIndicator()
            isDataLoading = true

            youTubeManager.fetchFeedItems(pageToken: nextPageToken) { [weak self] result in
                self?.handleFeedResult(result: result)
            }
        }
    }

    func startActivityIndicator() {
        tableView.tableFooterView = activityIndicator
        activityIndicator.startAnimating()
    }

    func stopActivityIndicator() {
        activityIndicator.stopAnimating()
        tableView.tableFooterView = nil
    }
}
