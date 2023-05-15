//
//  DropProjectNavigatorView.swift
//  RugbyPlanner
//
//  Created by Vyacheslav Khorkov on 09.05.2023.
//

import ComposableArchitecture
import SwiftUI

struct DropProjectNavigatorView: View {
    let store: Store<Void, ProjectNavigatorReducer.Action>
    @Binding var isTargeted: Bool

    var body: some View {
        WithViewStore(store) { viewStore in
            GeometryReader { _ in
                ZStack {
                    isTargeted ? Color.clear : Color.black.opacity(0.2)

                    VStack(alignment: .center, spacing: 10) {
                        Image(systemName: "tray.and.arrow.down")
                            .font(.system(size: 18))
                        Text(String.dragHelp)
                            .multilineTextAlignment(.center)
                            .font(.body)
                    }
                    .padding()
                    .foregroundColor(.secondary)
                }
            }
            .dropDestination(for: URL.self, action: { items, _ in
                guard let fileURL = items.first else { return false }
                viewStore.send(.readWorkspace(fileURL))
                return true
            }, isTargeted: { isTargeted = $0 })
        }
    }
}

private extension String {
    static let dragHelp = "Drag .xcworkspace file\nhere"
}
