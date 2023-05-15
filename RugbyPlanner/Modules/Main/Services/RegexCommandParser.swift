//
//  RegexCommandParser.swift
//  RugbyPlanner
//
//  Created by Vyacheslav Khorkov on 16.05.2023.
//

struct RegexCommandParser {
    func filterRegex(
        command: Command
    ) throws -> (targetsRegex: Regex<AnyRegexOutput>?, exceptTargetsRegex: Regex<AnyRegexOutput>?) {
        (
            try regex(patterns: command.targetsAsRegex, exactMatches: command.targets),
            try regex(patterns: command.exceptAsRegex, exactMatches: command.exceptTargets)
        )
    }

    private func regex(patterns: [String], exactMatches: [String]) throws -> Regex<AnyRegexOutput>? {
        guard !patterns.isEmpty || !exactMatches.isEmpty else { return nil }
        let exactMatches = exactMatches.map { "^\($0)$" }
        let joinedStrings = (patterns + exactMatches).joined(separator: "|")
        let regexString = "(" + joinedStrings + ")"
        return try Regex(regexString)
    }
}
