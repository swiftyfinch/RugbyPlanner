//
//  XcodeWorkspaceReaderDependency.swift
//  RugbyPlanner
//
//  Created by Vyacheslav Khorkov on 08.05.2023.
//

import ComposableArchitecture

extension XcodeWorkspaceReader: DependencyKey {
    static let liveValue = Self()
}

extension DependencyValues {
    var xcodeWorkspaceReader: XcodeWorkspaceReader {
        get { self[XcodeWorkspaceReader.self] }
        set { self[XcodeWorkspaceReader.self] = newValue }
    }
}
