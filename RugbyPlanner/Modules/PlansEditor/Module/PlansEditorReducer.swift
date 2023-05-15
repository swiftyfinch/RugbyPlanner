//
//  PlansEditorReducer.swift
//  RugbyPlanner
//
//  Created by Vyacheslav Khorkov on 07.05.2023.
//

import ComposableArchitecture
import Foundation

struct PlansEditorReducer: ReducerProtocol {
    typealias State = PlansEditorState

    enum Action {
        case readPlan(URL)
        case updateContent(URL, String)
        case parsePlans(URL, String)
        case selectPlan(Plan.ID)
        case handleError(Error)
        case hideAlert
    }

    @Dependency(\.plansEditor) var plansEditor
    @Dependency(\.plansParser) var plansParser

    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case let .readPlan(plansFileURL):
            plansEditor.tryCreateEmptyPlans(plansFileURL)
            do {
                let content = try plansEditor.read(plansFileURL)
                return .send(.parsePlans(plansFileURL, content))
            } catch {
                return .send(.handleError(error))
            }
        case let .updateContent(plansFileURL, content):
            return .send(.parsePlans(plansFileURL, content))
                .throttle(id: "parsePlans", for: 1, scheduler: DispatchQueue.main.eraseToAnyScheduler(), latest: true)
        case let .parsePlans(plansFileURL, content):
            do {
                try plansEditor.write(content, fileURL: plansFileURL)
                let plans = (try? plansParser.parse(content: content)) ?? []
                state.content = .ready(plansFileURL, content, plans)
                if let firstPlan = plans.first, state.selectedPlanId.isEmpty {
                    return .send(.selectPlan(firstPlan.id))
                }
                return .none
            } catch {
                return .send(.handleError(error))
            }
        case .selectPlan(let id):
            state.selectedPlanId = id
            return .none
        case let .handleError(error):
            state.content = .error(error)
            return .none
        case .hideAlert:
            state.content = .empty
            return .none
        }
    }
}
