//
//  XcodeProjectReader.swift
//  RugbyPlanner
//
//  Created by Vyacheslav Khorkov on 08.05.2023.
//

import Foundation
import XcodeProj

struct XcodeProjectReader {
    func read(_ fileURLs: [URL]) async throws -> [(name: String, project: XcodeProj)] {
        try await fileURLs.concurrentCompactMap(read)
    }

    func read(_ fileURL: URL) throws -> (name: String, project: XcodeProj)? {
        let project = try XcodeProj(pathString: fileURL.path())
        let name = fileURL.deletingPathExtension().lastPathComponent
        return (name, project)
    }
}
