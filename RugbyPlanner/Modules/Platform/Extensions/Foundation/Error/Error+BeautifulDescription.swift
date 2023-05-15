//
//  Error+BeautifulDescription.swift
//  RugbyPlanner
//
//  Created by Vyacheslav Khorkov on 08.05.2023.
//

import Foundation

extension Error {
    var beautifulDescription: String {
        let localizedDescription = (self as? LocalizedError)?.errorDescription
        return localizedDescription ?? String(describing: self)
    }
}
