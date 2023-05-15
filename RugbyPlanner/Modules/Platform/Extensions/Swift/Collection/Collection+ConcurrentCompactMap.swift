//
//  Collection+ConcurrentCompactMap.swift
//  RugbyPlanner
//
//  Created by Vyacheslav Khorkov on 08.05.2023.
//

extension Collection {
    @discardableResult
    func concurrentCompactMap<T>(
        maxInParallel: Int = Int.max,
        _ transform: @escaping (Element) async throws -> T?
    ) async rethrows -> [T] {
        try await concurrentMap(
            maxInParallel: maxInParallel,
            transform
        ).compactMap { $0 }
    }
}
