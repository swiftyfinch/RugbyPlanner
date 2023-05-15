//
//  ProjectNavigatorTreeBuilder.swift
//  RugbyPlanner
//
//  Created by Vyacheslav Khorkov on 09.05.2023.
//

struct ProjectNavigatorTreeBuilder {
    struct Modifier: OptionSet {
        let rawValue: Int

        static let hideAggregateTargets = Modifier(rawValue: 1 << 0)
        static let hideTargets = Modifier(rawValue: 1 << 1)
    }

    func buildTree(project: Project, modifiers: Modifier) -> ProjectNavigatorTree {
        let targets: [Target]? = project.targets.isEmpty ? nil : project.targets.keys.sorted()
        let filteredTargets = filterTargets(targets, modifiers: modifiers)
        return .init(
            id: project.name,
            name: project.name,
            type: .project,
            subtrees: filteredTargets?.map {
                buildTree(target: $0, targets: project.targets, parentId: project.name)
            }
        )
    }

    private func filterTargets(_ targets: [Target]?, modifiers: Modifier) -> [Target]? {
        guard let targets, !modifiers.isEmpty else { return targets }
        return targets.filter { target in
            if modifiers.contains(.hideAggregateTargets), target.type == .aggregated {
                return false
            } else if modifiers.contains(.hideTargets), target.modifier != nil {
                return false
            }
            return true
        }
    }

    private func buildTree(
        target: Target,
        targets: [Target: [Target]],
        parentId: String,
        depth: Int = 0
    ) -> ProjectNavigatorTree {
        .init(
            id: "\(parentId).\(target.name)",
            name: target.name,
            type: .target(target.type),
            modifier: target.modifier
        )
    }
}
