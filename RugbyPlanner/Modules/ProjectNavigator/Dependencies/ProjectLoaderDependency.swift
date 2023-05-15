//
//  ProjectLoaderDependency.swift
//  RugbyPlanner
//
//  Created by Vyacheslav Khorkov on 13.05.2023.
//

import ComposableArchitecture

extension ProjectLoader: DependencyKey {
    static let liveValue = Self()
}

extension DependencyValues {
    var projectLoader: ProjectLoader {
        get { self[ProjectLoader.self] }
        set { self[ProjectLoader.self] = newValue }
    }
}
