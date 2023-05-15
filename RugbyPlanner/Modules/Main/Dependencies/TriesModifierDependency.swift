//
//  TriesModifierDependency.swift
//  RugbyPlanner
//
//  Created by Vyacheslav Khorkov on 13.05.2023.
//

import ComposableArchitecture

extension TriesModifier: DependencyKey {
    static let liveValue = Self()
}

extension DependencyValues {
    var triesModifier: TriesModifier {
        get { self[TriesModifier.self] }
        set { self[TriesModifier.self] = newValue }
    }
}
