//
//  PlansParser.swift
//  RugbyPlanner
//
//  Created by Vyacheslav Khorkov on 10.05.2023.
//

import Foundation
import Yams

struct PlansParser {
    enum Error: LocalizedError {
        case incorrectFormat
        case noPlans

        public var errorDescription: String? {
            let output: String
            switch self {
            case .incorrectFormat:
                output = "Incorrect plans format."
            case .noPlans:
                output = "Couldn't find any plans."
            }
            return output
        }
    }

    func parse(content: String) throws -> [Plan] {
        let firstPlan = try parseTopPlan(content)
        let yaml = try Yams.load(yaml: content)
        guard let rawPlans = yaml as? [String: [[String: Any]]] else {
            throw Error.incorrectFormat
        }

        // Bubbling up the 1st plan
        let sortedPlans = rawPlans.sorted { lhs, _ in lhs.key == firstPlan }
        return sortedPlans.map { Plan(name: $0.key, commands: $0.value.map(Command.init)) }
    }

    private func parseTopPlan(_ content: String) throws -> String {
        guard let firstPlan = content.firstMatch(of: /^([\w-]+)(?=:)/.anchorsMatchLineEndings()) else {
            throw Error.noPlans
        }
        return String(firstPlan.output.0)
    }
}
