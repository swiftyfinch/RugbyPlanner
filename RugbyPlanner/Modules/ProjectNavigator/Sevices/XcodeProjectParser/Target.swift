//
//  Target.swift
//  RugbyPlanner
//
//  Created by Vyacheslav Khorkov on 08.05.2023.
//

final class Target {
    let name: String
    let type: TargetType
    var modifier: Modifier?

    init(name: String,
         type: TargetType,
         modifier: Modifier? = nil) {
        self.name = name
        self.type = type
        self.modifier = modifier
    }
}

extension Target {
    enum TargetType: Equatable {
        case podsUmbrella
        case tests
        case bundle
        case framework
        case aggregated
        case application
    }

    enum Modifier: Equatable {
        case hidden
        case build
    }
}

extension Target: Hashable, Comparable {
    static func < (lhs: Target, rhs: Target) -> Bool {
        lhs.name < rhs.name
    }

    static func == (lhs: Target, rhs: Target) -> Bool {
        lhs.name == rhs.name
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}
