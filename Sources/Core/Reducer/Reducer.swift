//
//  Reducer.swift
//  TinyCore
//
//  Created by Roy Hsu on 2019/3/14.
//  Copyright © 2019 TinyWorld. All rights reserved.
//

// MARK: - Reducer

/// A reducer can reduce a sequence of async actions to produce a new value.
///
/// Note: the following example is pseudo code.
/// ```
/// let authorizedUserReducer = Reducer<UUID, User?>(
///     initialValue: nil,
///     actions: [
///         .restoreFromKeychain,
///         .authorizeFromServer
///     ]
/// )
///
/// authorizedUserReducer.reduce { reducer in
///
///     guard let authorizedUser = reducer.currentValue else {
///
///          print("No available authorized user.")
///
///          return
///
///     }
///
/// }
///
/// ```
public final class Reducer<Identifier, Value> where Identifier: Hashable {

    private let _storage: Atomic<Storage>

    public init(
        initialValue: Value,
        actions: [Action] = []
    ) {

        self._storage = Atomic(
            value: Storage(
                currentValue: initialValue,
                actions: actions
            )
        )

    }

}

// MARK: - Action

extension Reducer {

    public typealias Action = ReducibleAction<Identifier, Value>

}

extension Reducer {

    public func reduce(completion: @escaping (Reducer) -> Void) {

        if isReducing { fatalError("The reducer must not reduce itself while it's reducing.") }

        _storage.mutateValue {

            $0.isReducing = true

            $0.completion = completion

            $0.pendingActions = $0.actions

        }

        reducePendingActions()

    }

    private func reducePendingActions() {

        var newPendingActions = pendingActions

        let areAllPendingActionsReduced = newPendingActions.isEmpty

        if areAllPendingActionsReduced { complete(); return }

        let nextAction = newPendingActions.removeFirst()

        _storage.mutateValue { $0.pendingActions = newPendingActions }

        nextAction.handler(currentValue) { newValue in

            self._storage.mutateValue { $0.currentValue = newValue }

            self.reducePendingActions()

        }

    }

    private func complete() {

        let completion = _storage.value.completion

        _storage.mutateValue {

            $0.isReducing = false

            $0.completion = nil

        }

        // Due to the limiation of the current atomic implementation. The mutating is an async operation.
        // We can make sure to call the getter on the atomic value to get the correct mutated value after the mutating scope, becuase the getter is a sync operation.
        precondition(_storage.value.completion == nil)

        completion?(self)

    }

}

extension Reducer {

    public var isReducing: Bool { return _storage.value.isReducing }

    public var currentValue: Value { return _storage.value.currentValue }

    public var actions: [Action] {

        get { return _storage.value.actions }

        set { _storage.mutateValue { $0.actions.append(contentsOf: newValue) } }

    }

    var pendingActions: [Action] { return _storage.value.pendingActions }

}

// MARK: - Storage

extension Reducer {

    private struct Storage {

        var isReducing = false

        var currentValue: Value

        var actions: [Action]

        var pendingActions: [Action] = []

        var completion: ( (Reducer) -> Void )?

        init(
            currentValue: Value,
            actions: [Action]
        ) {

            self.currentValue = currentValue

            self.actions = actions

        }

    }

}
