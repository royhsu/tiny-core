//
//  OptionalValueBinding.swift
//  TinyCore
//
//  Created by Roy Hsu on 2018/12/12.
//  Copyright © 2018 TinyWorld. All rights reserved.
//

// MARK: - OptionalValueBinding

internal final class OptionalValueBinding<Target: AnyObject, T, U>: Binding {

    private final let queue: DispatchQueue

    private final let transform: (T?) -> U?

    public final var target: AnyObject? { return _target }

    private final weak var _target: Target?

    private final let keyPath: ReferenceWritableKeyPath<Target, U?>

    internal init(
        queue: DispatchQueue,
        transform: @escaping (T?) -> U?,
        target: Target,
        keyPath: ReferenceWritableKeyPath<Target, U?>
    ) {

        self.queue = queue

        self.transform = transform

        self._target = target

        self.keyPath = keyPath

    }

    internal final func update(with value: T?) {

        queue.async { self._target?[keyPath: self.keyPath] = self.transform(value) }

    }

}
