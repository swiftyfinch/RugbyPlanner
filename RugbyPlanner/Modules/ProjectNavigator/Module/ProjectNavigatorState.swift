//
//  ProjectNavigatorState.swift
//  RugbyPlanner
//
//  Created by Vyacheslav Khorkov on 08.05.2023.
//

struct ProjectNavigatorState: Equatable {
    enum ProjectState {
        case empty
        case loading
        case ready([Project])
        case error(Error)
    }

    var project = ProjectState.empty
    var tries: [ProjectNavigatorTree] = []
    var modifiers: ProjectNavigatorTreeBuilder.Modifier = []
}

extension ProjectNavigatorState {
    var projects: [Project] {
        switch project {
        case let .ready(projects):
            return projects
        default:
            return []
        }
    }
}

extension ProjectNavigatorState.ProjectState: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.empty, .empty), (.loading, .loading), (.ready, .ready):
            return true
        case let (.error(lhsError), .error(rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        default:
            return false
        }
    }
}
