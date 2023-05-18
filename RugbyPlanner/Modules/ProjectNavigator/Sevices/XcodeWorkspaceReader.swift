//
//  XcodeWorkspaceReader.swift
//  RugbyPlanner
//
//  Created by Vyacheslav Khorkov on 08.05.2023.
//

import Foundation
import XcodeProj

struct XcodeWorkspaceReader {
    func readProjects(_ fileURL: URL) throws -> [URL] {
        try XCWorkspace(pathString: fileURL.path())
            .data.children
            .map(\.location.path)
            .filter { $0.hasSuffix(".xcodeproj") }
            .map { fileURL.deletingLastPathComponent().appending(path: $0) }
    }
}
