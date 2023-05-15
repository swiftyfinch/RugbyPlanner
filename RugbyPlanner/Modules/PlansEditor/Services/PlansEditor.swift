//
//  PlansEditor.swift
//  RugbyPlanner
//
//  Created by Vyacheslav Khorkov on 10.05.2023.
//

import Foundation

struct PlansEditor {
    let fileManager: FileManager
    let filesManager: FilesManager

    func tryCreateEmptyPlans(_ fileURL: URL) {
        guard !fileManager.fileExists(atPath: fileURL.path()) else { return }
        let content = "# Write your first plan here\n".data(using: .utf8)
        fileManager.createFile(atPath: fileURL.path(), contents: content)
    }

    func read(_ fileURL: URL) throws -> String {
        try filesManager.read(fileURL)
    }

    func write(_ content: String, fileURL: URL) throws {
        try filesManager.write(content, fileURL: fileURL)
    }
}
