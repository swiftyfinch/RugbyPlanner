//
//  XcodeTargetsParserDependency.swift
//  RugbyPlanner
//
//  Created by Vyacheslav Khorkov on 08.05.2023.
//

import ComposableArchitecture

extension XcodeTargetsParser: DependencyKey {
    static let liveValue = Self()
}

extension DependencyValues {
    var xcodeTargetsParser: XcodeTargetsParser {
        get { self[XcodeTargetsParser.self] }
        set { self[XcodeTargetsParser.self] = newValue }
    }
}
