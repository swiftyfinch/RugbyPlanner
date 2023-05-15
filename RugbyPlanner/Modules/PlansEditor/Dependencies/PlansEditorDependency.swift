//
//  PlansEditorDependency.swift
//  RugbyPlanner
//
//  Created by Vyacheslav Khorkov on 09.05.2023.
//

import ComposableArchitecture

extension PlansEditor: DependencyKey {
    static let liveValue = Self(fileManager: .default,
                                filesManager: FilesManager())
}

extension DependencyValues {
    var plansEditor: PlansEditor {
        get { self[PlansEditor.self] }
        set { self[PlansEditor.self] = newValue }
    }
}
