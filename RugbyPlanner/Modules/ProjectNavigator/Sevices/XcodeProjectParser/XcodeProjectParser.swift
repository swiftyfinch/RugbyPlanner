//
//  XcodeProjectParser.swift
//  RugbyPlanner
//
//  Created by Vyacheslav Khorkov on 08.05.2023.
//

import XcodeProj

struct XcodeTargetsParser {
    func parse(project: XcodeProj) -> [Target: [Target]] {
        guard let pbxTargets = project.pbxproj.projects.first?.targets else { return [:] }

        var targets: [Target: [Target]] = [:]
        var mapTargets: [String: Target] = [:]
        for pbxTarget in pbxTargets {
            guard let target = makeOrReuseTarget(pbxTarget, targets: &mapTargets) else { continue }
            targets[target] = parseDependencies(of: pbxTarget, targets: &mapTargets)
        }
        return targets
    }

    private func parseDependencies(of pbxTarget: PBXTarget, targets: inout [String: Target]) -> [Target] {
        pbxTarget.dependencies.compactMap { dependency in
            dependency.target.flatMap {
                makeOrReuseTarget($0, targets: &targets)
            }
        }
    }

    private func makeOrReuseTarget(_ pbxTarget: PBXTarget, targets: inout [String: Target]) -> Target? {
        if let exist = targets[pbxTarget.name] { return exist }

        guard let type = convertTargetType(of: pbxTarget) else { return nil }
        let target = Target(name: pbxTarget.name, type: type)
        targets[target.name] = target
        return target
    }

    private func convertTargetType(of pbxTarget: PBXTarget) -> Target.TargetType? {
        if pbxTarget.name.hasPrefix("Pods-") {
            return .podsUmbrella
        } else if pbxTarget.productType == .framework {
            return .framework
        } else if pbxTarget.productType == .bundle {
            return .bundle
        } else if pbxTarget.productType == .unitTestBundle || pbxTarget.productType == .uiTestBundle {
            return .tests
        } else if pbxTarget is PBXAggregateTarget {
            return .aggregated
        } else if pbxTarget.productType == .application {
            return .application
        }
        return nil
    }
}
