//
//  GitHubAPIClient.swift
//  ComposableGitHubApiApp
//
//  Created by 伊藤凌也 on 2020/05/31.
//  Copyright © 2020 ry-itto. All rights reserved.
//

import ComposableArchitecture
import Combine
import Foundation

struct GitHubAPIClientID: Hashable {}

struct GitHubAPIClient {
    private let hostURL: URL = URL(string: "https://api.github.com")!

    func fetchRepositories(_ query: String) -> Effect<[Repository], Error> {
        guard !query.isEmpty else { return .cancel(id: GitHubAPIClientID()) }
        let requestURL = hostURL.appendingPathComponent("/search/repositories")
        var components = URLComponents(url: requestURL, resolvingAgainstBaseURL: false)
        components?.queryItems = [
            URLQueryItem(name: "q", value: query)
        ]

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        guard let url = components?.url else {
            return .cancel(id: GitHubAPIClientID())
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: Repositories.self, decoder: decoder)
            .map(\.items)
            .eraseToEffect()
    }
}
