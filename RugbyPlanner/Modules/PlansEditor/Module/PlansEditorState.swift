//
//  PlansEditorState.swift
//  RugbyPlanner
//
//  Created by Vyacheslav Khorkov on 09.05.2023.
//

import Foundation

struct PlansEditorState: Equatable {
    var content = Content.empty
    var selectedPlanId: Plan.ID = ""
}

extension PlansEditorState {
    enum Content {
        case empty
        case ready(URL, String, [Plan])
        case error(Error)
    }
}

extension PlansEditorState {
    var plans: [Plan]? {
        switch content {
        case let .ready(_, _, plans):
            return plans
        default:
            return nil
        }
    }

    var selectedPlan: Plan? {
        plans?.first(where: { $0.id == selectedPlanId })
    }
}

extension PlansEditorState.Content: Equatable {
    static func == (lhs: PlansEditorState.Content, rhs: PlansEditorState.Content) -> Bool {
        switch (lhs, rhs) {
        case (.empty, .empty):
            return true
        case let (.ready(lhsURL, lhsString, lhsPlans), .ready(rhsURL, rhsString, rhsPlans)):
            return (lhsURL, lhsString, lhsPlans) == (rhsURL, rhsString, rhsPlans)
        case let (.error(lhsError), .error(rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        default:
            return false
        }
    }
}
