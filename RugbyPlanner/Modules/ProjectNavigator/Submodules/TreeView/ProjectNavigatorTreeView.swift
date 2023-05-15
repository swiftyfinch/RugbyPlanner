//
//  ProjectNavigatorTreeView.swift
//  RugbyPlanner
//
//  Created by Vyacheslav Khorkov on 09.05.2023.
//

import ComposableArchitecture
import SwiftUI

struct ProjectNavigatorTreeView: View {
    let store: StoreOf<ProjectNavigatorReducer>

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            List(
                viewStore.tries,
                children: \.subtrees
            ) { tree in
                HStack(spacing: 3) {
                    makeIcon(forTree: tree)
                    makeLabel(forTree: tree)
                }
                .opacity(tree.modifier == .hidden ? 0.3 : 1)
                .foregroundColor(tree.modifier == .build ? Color(hex: 0xb36541) : nil)
            }
            .listStyle(.inset)
        }
    }

    private func makeLabel(forTree tree: ProjectNavigatorTree) -> some View {
        let subtreesCount = tree.subtrees?.count
        let title = subtreesCount.map { "\(tree.name) (\($0))" } ?? tree.name
        return Text(title)
            .lineLimit(1)
            .truncationMode(.middle)
    }

    private func makeIcon(forTree tree: ProjectNavigatorTree) -> some View {
        switch tree.type {
        case .project:
            return AnyView(
                Image(systemName: "character.book.closed.fill")
                    .foregroundStyle(Color(hex: 0x3a95ff))
                    .fontWeight(.semibold)
            )
        case let .target(type):
            if tree.modifier == .build {
                return AnyView(
                    Image(systemName: "football")
                        .foregroundStyle(Color(hex: 0xb36541))
                )
            }
            switch type {
            case .tests:
                return AnyView(
                    Image(systemName: "checkmark.diamond.fill")
                        .foregroundStyle(.white, Color(hex: 0x73c345))
                        .fontWeight(.black)
                )
            case .bundle:
                return AnyView(
                    Image(systemName: "batteryblock.fill")
                        .foregroundColor(.init(hex: 0x6eb5dC))
                )
            case .podsUmbrella, .framework:
                return AnyView(
                    Image(systemName: "latch.2.case.fill")
                        .foregroundColor(.init(hex: 0xfbc642))
                )
            case .aggregated:
                return AnyView(
                    Image(systemName: "target")
                        .foregroundColor(.init(hex: 0xca6854))
                )
            case .application:
                return AnyView(
                    Image(systemName: "a.square.fill")
                        .imageScale(.large)
                        .fontWeight(.semibold)
                        .foregroundStyle(.gray)
                )
            }
        }
    }
}
