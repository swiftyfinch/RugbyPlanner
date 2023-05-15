//
//  MainReducer.swift
//  RugbyPlanner
//
//  Created by Vyacheslav Khorkov on 07.05.2023.
//

import ComposableArchitecture

struct MainReducer: ReducerProtocol {
    struct State: Equatable {
        var projectNavigator: ProjectNavigatorReducer.State
        var plansEditor: PlansEditorReducer.State

        var readyToRun: Bool {
            !projectNavigator.tries.isEmpty && plansEditor.selectedPlan != nil
        }
    }

    enum Action {
        case projectNavigator(ProjectNavigatorReducer.Action)
        case plansEditor(PlansEditorReducer.Action)
        case applyPlan
    }

    @Dependency(\.triesModifier) var triesModifier

    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case let .projectNavigator(action):
                switch action {
                case let .readWorkspace(fileURL):
                    let plansFileURL = fileURL.deletingLastPathComponent().appending(path: String.rugbyPlans)
                    return .send(.plansEditor(.readPlan(plansFileURL)))
                default:
                    return .none
                }
            case .plansEditor:
                return .none
            case .applyPlan:
                guard let selectedPlan = state.plansEditor.selectedPlan else { return .none }
                let projects = state.projectNavigator.projects
                return .task {
                    do {
                        try triesModifier.applyPlan(selectedPlan, to: projects)
                        return .projectNavigator(.buildTree)
                    } catch {
                        return .projectNavigator(.handleError(error))
                    }
                }
            }
        }
        .child(\.projectNavigator, action: /Action.projectNavigator) {
            ProjectNavigatorReducer()
        }
        .child(\.plansEditor, action: /Action.plansEditor) {
            PlansEditorReducer()
        }
    }
}

private extension String {
    static let rugbyPlans = ".rugby/plans.yml"
}
