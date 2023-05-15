//
//  TriesModifier.swift
//  RugbyPlanner
//
//  Created by Vyacheslav Khorkov on 13.05.2023.
//

import ComposableArchitecture

struct TriesModifier {
    @Dependency(\.targetsResolver) var targetsResolver
    @Dependency(\.regexCommandParser) var regexCommandParser

    func applyPlan(_ plan: Plan, to projects: [Project]) throws {
        guard let podsProject = projects.first(where: { $0.name == "Pods" }) else { return }
        reset(projects)

        for command in plan.commands {
            switch command.name {
            case "delete":
                try applyDelete(command, projects: projects)
            case "cache", "use":
                try applyCache(command, to: podsProject)
            default:
                break
            }
        }
    }

    private func applyDelete(_ command: Command, projects: [Project]) throws {
        let project: Project
        if let path = command.path,
           let projectName = path.components(separatedBy: ".").first,
           let customProject = projects.first(where: { $0.name == projectName }) {
            project = customProject
        } else if let podsProject = projects.first(where: { $0.name == "Pods" }) {
            project = podsProject
        } else {
            return
        }

        let regex = try regexCommandParser.filterRegex(command: command)
        try targetsResolver.resolveTargets(
            targets: Array(project.targets.keys),
            targetsMap: project.targets,
            by: regex.targetsRegex,
            except: regex.exceptTargetsRegex,
            includingDependencies: false
        )
        .modifyIf(command.safe) { targets in
            var result = Set(targets)
            let allDependencies = Set(project.targets.values.flatMap { $0 })
                .subtracting(targets)
            allDependencies.forEach {
                var dependencies: Set<Target> = []
                targetsResolver.findTargetsInTree(
                    target: $0,
                    targetsMap: project.targets,
                    targets: &dependencies
                )
                let intersection = dependencies.intersection(targets)
                result.subtract(intersection)
            }
            targets = Array(result)
        }
        .filter {
            $0.type != .aggregated && $0.type != .podsUmbrella
        }
        .forEach {
            $0.modifier = .hidden
        }
    }

    private func applyCache(_ command: Command, to project: Project) throws {
        let regex = try regexCommandParser.filterRegex(command: command)
        try targetsResolver.resolveTargets(
            targets: Array(project.targets.keys),
            targetsMap: project.targets,
            by: regex.targetsRegex,
            except: regex.exceptTargetsRegex,
            includingDependencies: true
        )
        .filter {
            ($0.type == .framework || $0.type == .bundle) && $0.modifier == nil
        }
        .forEach {
            $0.modifier = .build
        }
    }

    private func reset(_ projects: [Project]) {
        projects.forEach {
            $0.targets.forEach {
                $0.key.modifier = nil
            }
        }
    }
}
