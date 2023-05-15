//
//  MainView.swift
//  RugbyPlanner
//
//  Created by Vyacheslav Khorkov on 07.05.2023.
//

import ComposableArchitecture
import SwiftUI

struct MainView: View {
    let store: StoreOf<MainReducer>

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            NavigationView {
                ProjectNavigatorView(
                    store: store.scope(
                        state: \.projectNavigator,
                        action: MainReducer.Action.projectNavigator
                    )
                )
                .frame(minWidth: 200)
                .toolbar {
                    toolbar(viewStore: viewStore)
                }

                PlansEditorView(
                    store: store.scope(
                        state: \.plansEditor,
                        action: MainReducer.Action.plansEditor
                    )
                )
                .frame(minWidth: 300)
            }
        }
    }

    private func toolbar(
        viewStore: ViewStore<MainReducer.State, MainReducer.Action>
    ) -> some ToolbarContent {
        ToolbarItemGroup {
            Button(action: {
                NSApplication.toggleSidebar()
            }, label: {
                Image(systemName: "sidebar.left")
            })
            .help("Hide or show the Navigator")

            if viewStore.state.readyToRun {
                Spacer()
                Button(action: {
                    viewStore.send(.applyPlan)
                }, label: {
                    Image(systemName: "play.fill")
                })
                .help("Apply the active plan")
            }
        }
    }
}
