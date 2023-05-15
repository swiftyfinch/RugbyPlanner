//
//  ProjectNavigatorTreeBuilderDependency.swift
//  RugbyPlanner
//
//  Created by Vyacheslav Khorkov on 09.05.2023.
//

import ComposableArchitecture

extension ProjectNavigatorTreeBuilder: DependencyKey {
    static let liveValue = Self()
}

extension DependencyValues {
    var projectNavigatorTreeBuilder: ProjectNavigatorTreeBuilder {
        get { self[ProjectNavigatorTreeBuilder.self] }
        set { self[ProjectNavigatorTreeBuilder.self] = newValue }
    }
}
