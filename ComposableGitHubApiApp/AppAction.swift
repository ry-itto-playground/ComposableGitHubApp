//
//  AppAction.swift
//  ComposableGitHubApiApp
//
//  Created by 伊藤凌也 on 2020/05/31.
//  Copyright © 2020 ry-itto. All rights reserved.
//

enum AppAction {
    case queryChanged(text: String)
    case load
    case repositoriesResponse(Result<[Repository], Error>)
}
