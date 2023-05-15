//
//  TargetsResolver.swift
//  RugbyPlanner
//
//  Created by Vyacheslav Khorkov on 16.05.2023.
//

struct TargetsResolver {
    func findTargetsInTree(
        target: Target,
        targetsMap: [Target: [Target]],
        targets: inout Set<Target>
    ) {
        guard !targets.contains(target) else { return }
        targets.insert(target)

        let dependencies = targetsMap[target] ?? []
        dependencies.forEach { target in
            findTargetsInTree(target: target, targetsMap: targetsMap, targets: &targets)
        }
    }

    func resolveTargets(targets: [Target],
                        targetsMap: [Target: [Target]],
                        by regex: Regex<AnyRegexOutput>?,
                        except exceptRegex: Regex<AnyRegexOutput>?,
                        includingDependencies: Bool) throws -> [Target] {
        targets.filter {
            if let regex = exceptRegex, $0.name.match(regex) {
                return false
            } else if let regex = regex {
                return $0.name.match(regex)
            }
            return true
        }
        .modifyIf(includingDependencies) { targets in
            var targetsSet: Set<Target> = []
            targets.forEach {
                findTargetsInTree(target: $0, targetsMap: targetsMap, targets: &targetsSet)
            }
            targets = Array(targetsSet)
        }
        .filter {
            if let regex = exceptRegex, $0.name.match(regex) {
                return false
            }
            return true
        }
    }
}
