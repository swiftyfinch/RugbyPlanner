//
//  PlansParserDependency.swift
//  RugbyPlanner
//
//  Created by Vyacheslav Khorkov on 10.05.2023.
//

import ComposableArchitecture

extension PlansParser: DependencyKey {
    static let liveValue = Self()
}

extension DependencyValues {
    var plansParser: PlansParser {
        get { self[PlansParser.self] }
        set { self[PlansParser.self] = newValue }
    }
}
