//
//  XcodeWorkspaceReader.swift
//  RugbyPlanner
//
//  Created by Vyacheslav Khorkov on 08.05.2023.
//

import Foundation
import XcodeProj

struct XcodeWorkspaceReader {
    /// Returns: - Project paths.
    func read(_ fileURL: URL) throws -> [URL] {
        let workspace = try XCWorkspace(pathString: fileURL.path())
        return workspace.data.children.map(\.location.path).map {
            fileURL.deletingLastPathComponent().appending(path: $0)
        }
    }
}
