//
//  FeedApiManager.swift
//  MyYoutube
//
//  Created by Мария Газизова on 25.07.2022.
//

import Foundation
import GTMSessionFetcher
import GoogleSignIn

class YouTubeApiManager {
    private let apiKey = "AIzaSyB6-_UvVMkvHoQ84jBqpDZDll3Bt8qoKNk"
    var shouldAuthorize: ((@escaping RateHandler) -> Void)?

    typealias FeedHandler = (Result<FeedModel, CustomError>) -> Void
    typealias ChannelsHandler = (Result<ChannelsModel, CustomError>) -> Void
    typealias RateHandler = (Result<Data?, CustomError>) -> Void

    func fetchFeedItems(pageToken: String?, completion: @escaping FeedHandler) {
        guard let url = YouTubeEndPoint.feedListWithSnippets(accessKey: apiKey, pageToken: pageToken).fullURL else {
            completion(.failure(CustomError.wrongURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let session = URLSession.shared
        session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            do {
                if let error = error { throw error }

                if let data = data {
                    let feed: FeedModel = try JSONDecoder().decode(FeedModel.self, from: data)
                    completion(.success(feed))
                }
            } catch let error as NSError {
                //TODO: describe the errors
                print("Error in feed items")
            }
        }).resume()
    }

    func fetchChannelsItems(channelsIds: [String], completion: @escaping ChannelsHandler) {
        guard let url = YouTubeEndPoint.channelInfoSnippet(accessKey: apiKey, channelsIds: channelsIds).fullURL else {
            completion(.failure(CustomError.wrongURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let session = URLSession.shared
        session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            do {
                if let error = error { throw error }

                if let data = data {
                    let channels: ChannelsModel = try JSONDecoder().decode(ChannelsModel.self, from: data)

                    completion(.success(channels))
                }
            } catch let error as NSError {
                //TODO: describe the errors
                print("Error in fetch channels")
            }
        }).resume()
    }

    func rate(video: String, with rate: Rate, completion: @escaping RateHandler) {
        if AuthenticationService.shared.user == nil {
            shouldAuthorize? { [weak self] result in
                switch result {
                case .success:
                    self?.rate(video: video, with: rate, completion: completion)
                case .failure:
                    // TODO: handle error
                    break
                }
            }
        }

        guard let url = YouTubeEndPoint.rateVideo(videoId: video, rate: rate).fullURL else {
            completion(.failure(CustomError.wrongURL))
            return
        }
        guard let user = AuthenticationService.shared.user else {
            //TODO: change error
            completion(.failure(CustomError.wrongURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(user.authentication.accessToken)", forHTTPHeaderField: "Authorization")

        let session = URLSession.shared
        session.dataTask(with: request as URLRequest, completionHandler: { data, response, error -> Void in
            do {
                if let error = error { throw error }

                if let httpResponse = response as? HTTPURLResponse,
                    httpResponse.statusCode == 204 {
                    completion(.success(data!))
                }
            } catch let error as NSError {
                //TODO: describe the errors
                print("Error in rate")
            }
        }).resume()
    }
}
