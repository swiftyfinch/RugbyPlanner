//
//  XcodeProjectReaderDependency.swift
//  RugbyPlanner
//
//  Created by Vyacheslav Khorkov on 08.05.2023.
//

import ComposableArchitecture

extension XcodeProjectReader: DependencyKey {
    static let liveValue = Self()
}

extension DependencyValues {
    var xcodeProjectReader: XcodeProjectReader {
        get { self[XcodeProjectReader.self] }
        set { self[XcodeProjectReader.self] = newValue }
    }
}
