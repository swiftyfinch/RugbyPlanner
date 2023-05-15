//
//  String+Match.swift
//  RugbyPlanner
//
//  Created by Vyacheslav Khorkov on 13.05.2023.
//

extension String {
    func match(_ regex: Regex<AnyRegexOutput>) -> Bool {
        wholeMatch(of: regex)?.isEmpty != nil
    }
}
