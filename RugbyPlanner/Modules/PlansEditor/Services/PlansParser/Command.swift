//
//  Command.swift
//  RugbyPlanner
//
//  Created by Khorkov Vyacheslav on 12.05.2023.
//

struct Command {
    private let raw: [String: Any]

    init(raw: [String: Any]) {
        self.raw = raw
    }
}

extension Command {
    var name: String? { raw["command"] as? String }

    var targetsAsRegex: [String] { parseArray(key: "targets-as-regex") }
    var targets: [String] { parseArray(key: "targets") }
    var exceptAsRegex: [String] { parseArray(key: "except-as-regex") }
    var exceptTargets: [String] { parseArray(key: "except") }

    var path: String? { raw["path"] as? String }
    var safe: Bool { raw["safe"] as? Bool ?? false }

    private func parseArray(key: String) -> [String] {
        let rawValue = raw[key]
        if let array = rawValue as? [String] {
            return array
        } else if let string = rawValue as? String {
            return [string]
        }
        return []
    }
}
