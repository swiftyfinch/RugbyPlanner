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
                    if viewStore.modifiers.contains(.hideTargets) {
                        Image(systemName: "eye.slash.circle.fill")
                            .imageScale(.medium)
                            .foregroundColor(Color.gray)
                    } else {
                        Image(systemName: "eye.circle.fill")
                            .imageScale(.medium)
                            .foregroundColor(.init(hex: 0x6eb5dC))
                    }
                }
                .buttonStyle(CustomButtonStyle())

                Button {
                    viewStore.send(.toggleAggregateTargetsVisibility)
                } label: {
                    Image(systemName: "target")
                        .imageScale(.medium)
                        .foregroundColor(
                            viewStore.modifiers.contains(.hideAggregateTargets) ? Color.gray : Color(hex: 0xca6854)
                        )
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
