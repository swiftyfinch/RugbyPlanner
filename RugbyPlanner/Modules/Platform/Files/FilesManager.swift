//
//  FilesManager.swift
//  RugbyPlanner
//
//  Created by Vyacheslav Khorkov on 09.05.2023.
//

import Foundation

struct FilesManager {
    enum Error: LocalizedError {
        case damagedData
        case damagedText

        var errorDescription: String? {
            switch self {
            case .damagedData:
                return "Can't encode text to data."
            case .damagedText:
                return "Can't encode data to text."
            }
        }
    }

    func read(_ fileURL: URL) throws -> String {
        let data = try Data(contentsOf: fileURL)
        guard let content = String(data: data, encoding: .utf8) else {
            throw Error.damagedText
        }
        return content
    }

    func write(_ content: String, fileURL: URL) throws {
        guard let data = content.data(using: .utf8) else {
            throw Error.damagedData
        }
        try data.write(to: fileURL)
    }
}
