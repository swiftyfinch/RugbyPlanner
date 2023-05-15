//
//  Project.swift
//  RugbyPlanner
//
//  Created by Vyacheslav Khorkov on 08.05.2023.
//

final class Project {
    let name: String
    var targets: [Target: [Target]]

    init(name: String, targets: [Target: [Target]]) {
        self.name = name
        self.targets = targets
    }
}
