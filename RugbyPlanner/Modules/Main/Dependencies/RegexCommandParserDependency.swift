//
//  RegexCommandParserDependency.swift
//  RugbyPlanner
//
//  Created by Vyacheslav Khorkov on 16.05.2023.
//

import ComposableArchitecture

extension RegexCommandParser: DependencyKey {
    static let liveValue = Self()
}

extension DependencyValues {
    var regexCommandParser: RegexCommandParser {
        get { self[RegexCommandParser.self] }
        set { self[RegexCommandParser.self] = newValue }
    }
}
