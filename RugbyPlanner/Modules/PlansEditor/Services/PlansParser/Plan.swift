//
//  Plan.swift
//  RugbyPlanner
//
//  Created by Vyacheslav Khorkov on 10.05.2023.
//

struct Plan: Identifiable {
    var id: String { name }
    let name: String
    let commands: [Command]
}

extension Plan: Equatable {
    static func == (lhs: Plan, rhs: Plan) -> Bool {
        (lhs.name, lhs.commands.description) == (rhs.name, rhs.commands.description)
    }
}
