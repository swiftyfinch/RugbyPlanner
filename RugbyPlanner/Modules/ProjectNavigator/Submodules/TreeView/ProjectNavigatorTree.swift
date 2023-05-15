//
//  ProjectNavigatorTree.swift
//  RugbyPlanner
//
//  Created by Vyacheslav Khorkov on 09.05.2023.
//

struct ProjectNavigatorTree: Identifiable {
    let id: String
    let name: String
    let type: TreeType
    let subtrees: [ProjectNavigatorTree]?
    let modifier: Target.Modifier?

    init(id: String,
         name: String,
         type: TreeType,
         subtrees: [ProjectNavigatorTree]? = nil,
         modifier: Target.Modifier? = nil) {
        self.id = id
        self.name = name
        self.type = type
        self.subtrees = subtrees
        self.modifier = modifier
    }
}

extension ProjectNavigatorTree {
    enum TreeType: Equatable {
        case project
        case target(Target.TargetType)
    }
}

extension ProjectNavigatorTree: Equatable {
    static func == (lhs: ProjectNavigatorTree, rhs: ProjectNavigatorTree) -> Bool {
        (lhs.id, lhs.name, lhs.type, lhs.subtrees, lhs.modifier)
        == (rhs.id, rhs.name, rhs.type, rhs.subtrees, rhs.modifier)
    }
}
