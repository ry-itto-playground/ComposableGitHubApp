//
//  ContentView.swift
//  ComposableGitHubApiApp
//
//  Created by 伊藤凌也 on 2020/05/31.
//  Copyright © 2020 ry-itto. All rights reserved.
//

import ComposableArchitecture
import StubKit
import SwiftUI


struct ContentView: View {
    let store: Store<AppState, AppAction>

    var body: some View {
        WithViewStore(self.store) { viewStore in
            VStack {
                TextField(
                    "検索ワード",
                    text: viewStore.binding(
                        get: { $0.query },
                        send: { .queryChanged(text: $0) }
                    )
                )
                .textFieldStyle(RoundedBorderTextFieldStyle())
                List {
                    ForEach(viewStore.repositories, id: \.id) { repository in
                        Text(repository.name)
                    }
                }
            }.onAppear {
                viewStore.send(.load)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(
            store: .init(
                initialState: AppState(
                    repositories: [
                        try! Stub.make(Repository.self),
                        try! Stub.make(Repository.self),
                        try! Stub.make(Repository.self)
                    ]
                ),
                reducer: appReducer.debug(),
                environment: AppEnvironment(
                    apiClient: .init(),
                    mainQueue: DispatchQueue.main.eraseToAnyScheduler()
                )
            )
        )
    }
}
