//
//  ProjectLoader.swift
//  RugbyPlanner
//
//  Created by Vyacheslav Khorkov on 13.05.2023.
//

import ComposableArchitecture
import Foundation

struct ProjectLoader {
    @Dependency(\.xcodeWorkspaceReader) var xcodeWorkspaceReader
    @Dependency(\.xcodeProjectReader) var xcodeProjectReader
    @Dependency(\.xcodeTargetsParser) var xcodeTargetsParser

    func load(workspace fileURL: URL) async throws -> [Project] {
        let projectPaths = try xcodeWorkspaceReader.read(fileURL)
        let projectsInfo = try await xcodeProjectReader.read(projectPaths)
        let projects = await projectsInfo.concurrentMap {
            Project(name: $0.name, targets: xcodeTargetsParser.parse(project: $0.project))
        }
        return projects
    }
}
