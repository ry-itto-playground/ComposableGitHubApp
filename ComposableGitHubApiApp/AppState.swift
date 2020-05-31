//
//  AppState.swift
//  ComposableGitHubApiApp
//
//  Created by 伊藤凌也 on 2020/05/31.
//  Copyright © 2020 ry-itto. All rights reserved.
//

import ComposableArchitecture
import Foundation

struct AppEnvironment {
    let apiClient: GitHubAPIClient
    let mainQueue: AnySchedulerOf<DispatchQueue>
}

struct AppState: Equatable {
    var query: String = ""
    var repositories: [Repository] = []

    static func == (lhs: AppState, rhs: AppState) -> Bool {
        return lhs.query == rhs.query
            && lhs.repositories.count == rhs.repositories.count
            && !(0..<lhs.repositories.count)
                .contains { lhs.repositories[$0].id != rhs.repositories[$0].id }
    }
}

let appReducer = Reducer<AppState, AppAction, AppEnvironment> { state, action, environment in
    switch action {
    case .queryChanged(let text):
        state.query = text
        return .init(value: .load)
    case .load:
        return environment.apiClient
            .fetchRepositories(state.query)
            .receive(on: environment.mainQueue)
            .catchToEffect()
            .map(AppAction.repositoriesResponse)
            .cancellable(id: GitHubAPIClientID(), cancelInFlight: true)
    case .repositoriesResponse(.success(let repositories)):
        state.repositories = repositories
    case .repositoriesResponse(.failure(let e)):
        assertionFailure(e.localizedDescription)
    }
    return .none
}
