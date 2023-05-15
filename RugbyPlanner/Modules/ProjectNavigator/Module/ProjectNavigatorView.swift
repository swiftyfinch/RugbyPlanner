//
//  ProjectNavigatorView.swift
//  RugbyPlanner
//
//  Created by Vyacheslav Khorkov on 07.05.2023.
//

import ComposableArchitecture
import SwiftUI

struct ProjectNavigatorView: View {
    let store: StoreOf<ProjectNavigatorReducer>

    @State private var isTargeted = false

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack(spacing: 0) {
                switch viewStore.project {
                case .empty:
                    separator()
                    DropProjectNavigatorView(store: store.stateless, isTargeted: $isTargeted)
                case .loading:
                    separator()
                    ZStack {
                        Color.black.opacity(0.2)
                        ProgressView().controlSize(.regular)
                    }
                case .ready:
                    ProjectNavigatorButtonsView(store: store).padding(4)
                    separator()
                    ZStack {
                        DropProjectNavigatorView(store: store.stateless, isTargeted: $isTargeted)
                            .opacity(isTargeted ? 1 : 0)

                        ProjectNavigatorTreeView(store: store)
                            .opacity(isTargeted ? 0 : 1)
                    }
                case .error(let error):
                    separator()
                    DropProjectNavigatorView(store: store.stateless, isTargeted: $isTargeted)
                        .alert(
                            error.beautifulDescription,
                            isPresented: .constant(true),
                            actions: {
                                Button("OK", role: .cancel, action: { viewStore.send(.hideAlert) })
                            }
                        )
                }
            }
        }
    }

    private func separator() -> some View {
        Color(white: 0.1).frame(height: 0.75)
    }
}
