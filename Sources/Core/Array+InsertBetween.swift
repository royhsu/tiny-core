//
//  Array+InsertBetween.swift
//  TinyCore
//
//  Created by Roy Hsu on 2018/4/5.
//  Copyright © 2018 TinyWorld. All rights reserved.
//

// MARK: - Insert Between

extension Array {

    /// You can specify the between to return nil for skipping the certain insertions.
    ///
    /// For example:
    ///
    /// let output = [ 1.0, 2.0, 3.0 ].insert { previous, next in
    ///
    ///     Only insert values if the previous is greater than or equal to 2.0
    ///     if previous >= 2.0 { return nil }
    ///
    ///     return (previous + next) / 2.0
    ///
    /// }
    ///
    /// The output is: [ 1.0, 1.5, 2.0, 3.0 ]
    ///
    public func inserted(
        between: (_ previous: Element, _ next: Element) -> Element?
    )
    -> [Element] {

        return reduce([]) { currentResult, next in

            var nextResult = currentResult

            guard
                let previous = currentResult.last,
                let between = between(previous, next)
            else { nextResult.append(next); return nextResult }

            nextResult.append(contentsOf: [ between, next ])

            return nextResult

        }

    }

    public mutating func insert(
        between: (_ previous: Element, _ next: Element) -> Element?
    ) { self = inserted(between: between) }

}
