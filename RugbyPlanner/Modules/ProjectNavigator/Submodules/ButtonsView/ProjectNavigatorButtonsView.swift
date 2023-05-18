//
//  ProjectNavigatorButtonsView.swift
//  RugbyPlanner
//
//  Created by Vyacheslav Khorkov on 13.05.2023.
//

import ComposableArchitecture
import SwiftUI

struct ProjectNavigatorButtonsView: View {
    let store: StoreOf<ProjectNavigatorReducer>

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            HStack {
                Button {
                    viewStore.send(.toggleModifiedTargetsVisibility)
                } label: {
                    Image(systemName: viewStore.showTargets ? "eye.circle.fill" : "eye.slash.circle.fill")
                        .imageScale(.medium)
                        .foregroundColor(viewStore.showTargets ? Color(hex: 0x6eb5dC) : Color.gray)
                        .help(viewStore.showTargets ? "Hide Targets" : "Show Targets")
                }
                .buttonStyle(CustomButtonStyle())

                Button {
                    viewStore.send(.toggleAggregateTargetsVisibility)
                } label: {
                    Image(systemName: "target")
                        .imageScale(.medium)
                        .foregroundColor(viewStore.showAggregateTargets ? Color(hex: 0xca6854) : Color.gray)
                        .help(viewStore.showAggregateTargets ? "Hide Aggregate Targets" : "Show Aggregate Targets")
                }
                .buttonStyle(CustomButtonStyle())
            }
        }
    }
}

private struct CustomButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.5 : 1)
    }
}

private extension ProjectNavigatorState {
    var showTargets: Bool { !modifiers.contains(.hideTargets) }
    var showAggregateTargets: Bool { !modifiers.contains(.hideAggregateTargets) }
}
