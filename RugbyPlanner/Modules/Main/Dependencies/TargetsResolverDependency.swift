//
//  TargetsResolverDependency.swift
//  RugbyPlanner
//
//  Created by Vyacheslav Khorkov on 16.05.2023.
//

import ComposableArchitecture

extension TargetsResolver: DependencyKey {
    static let liveValue = Self()
}

extension DependencyValues {
    var targetsResolver: TargetsResolver {
        get { self[TargetsResolver.self] }
        set { self[TargetsResolver.self] = newValue }
    }
}
