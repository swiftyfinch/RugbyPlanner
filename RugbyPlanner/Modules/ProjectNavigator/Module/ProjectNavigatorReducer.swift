//
//  ProjectNavigatorReducer.swift
//  RugbyPlanner
//
//  Created by Vyacheslav Khorkov on 07.05.2023.
//

import ComposableArchitecture
import Foundation

struct ProjectNavigatorReducer: ReducerProtocol {
    enum Action {
        case readWorkspace(_ fileURL: URL)
        case setProjects([Project])
        case buildTree
        case toggleAggregateTargetsVisibility
        case toggleModifiedTargetsVisibility
        case handleError(Error)
        case hideAlert
    }

    @Dependency(\.projectLoader) var projectLoader
    @Dependency(\.projectNavigatorTreeBuilder) var projectNavigatorTreeBuilder

    func reduce(into state: inout ProjectNavigatorState, action: Action) -> EffectTask<Action> {
        switch action {
        case .readWorkspace(let fileURL):
            guard fileURL.pathExtension == .xcworkspace else { return .none }

            state.project = .loading
            return .task {
                .setProjects(try await projectLoader.load(workspace: fileURL))
            } catch: {
                .handleError($0)
            }
        case let .setProjects(projects):
            state.project = .ready(projects)
            return .send(.buildTree)
        case .buildTree:
            state.tries = state.projects.map {
                projectNavigatorTreeBuilder.buildTree(project: $0, modifiers: state.modifiers)
            }
            return .none
        case .toggleAggregateTargetsVisibility:
            state.modifiers.formSymmetricDifference(.hideAggregateTargets)
            return .send(.buildTree)
        case .toggleModifiedTargetsVisibility:
            state.modifiers.formSymmetricDifference(.hideTargets)
            return .send(.buildTree)
        case let .handleError(error):
            state.project = .error(error)
            return .none
        case .hideAlert:
            state.project = .empty
            return .none
        }
    }
}

private extension String {
    static let xcworkspace = "xcworkspace"
}
