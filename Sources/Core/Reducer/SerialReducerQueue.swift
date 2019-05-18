//
//  SerialReducerQueue.swift
//  TinyCore
//
//  Created by Roy Hsu on 2019/5/18.
//  Copyright © 2019 TinyWorld. All rights reserved.
//

// MARK: - SerialReducerQueue

public struct SerialReducerQueue<State>: ExpressibleByArrayLiteral {
    
    private var reducers: [AnyReducer<State>]
    
    public init<R>(arrayLiteral reducers: R...)
    where
        R: Reducer,
        R.State == State { self.reducers = reducers.map(AnyReducer.init) }
    
    public init(arrayLiteral reducers: AnyReducer<State>...) {
        
        self.reducers = reducers
        
    }
    
}

// MARK: - Reducer

extension SerialReducerQueue: Reducer {
    
    public func reduce(
        _ initialState: State,
        completion: @escaping (State) -> Void
    ) {
     
        SerialReducerQueue.executeNextPendingReducers(
            reducers,
            with: initialState,
            completion: completion
        )
        
    }
    
    private static func executeNextPendingReducers<C>(
        _ reducers: C,
        with state: State,
        completion: @escaping (State) -> Void
    )
    where
        C: Collection,
        C.Element == AnyReducer<State> {
    
        guard let nextReducer = reducers.first else {
            
            completion(state)
            
            return
            
        }
        
        let remainingReducers = reducers.dropFirst()
        
        nextReducer.reduce(state) { newState in
            
            executeNextPendingReducers(
                remainingReducers,
                with: newState,
                completion: completion
            )
            
        }
        
    }
    
}

final class ReducerOperation<State>: Operation {
    
    private let _operationState = Atomic<OperationState>(.ready)
    
    private let _state: Atomic<State>
    
    private let reducer: AnyReducer<State>
    
    init<R>(
        initialState: State,
        reducer: R
    )
    where
        R: Reducer,
        R.State == State {
            
        self._state = Atomic(initialState)
            
        self.reducer = AnyReducer(reducer)
            
    }
    
    // MARK: Operation
    
    override var isAsynchronous: Bool { return true }
    
    override var isReady: Bool {
        
        switch operationState {
            
        case .executing, .finished, .cancelled: return false
            
        case .ready: return super.isReady
            
        }
        
    }
    
    override var isExecuting: Bool { return operationState == .executing }
    
    override var isFinished: Bool {
        
        return isCancelled || operationState == .finished
        
    }
    
    override func start() {
        
        if isCancelled { return }
        
        operationState = .executing
        
        reducer.reduce(_state.value) { newState in
            
            self._state.modify { $0 = newState }
            
            self.operationState = .finished
            
        }
        
    }
    
    override func cancel() {
        
        operationState = .cancelled
        
        super.cancel()
        
    }
    
    // MARK: KVO
    
    @objc
    class func keyPathsForValuesAffectingIsReady() -> Set<String> {
        
        return [ "operationState" ]
        
    }
    
    @objc
    class func keyPathsForValuesAffectingIsExecuting() -> Set<String> {
        
        return [ "operationState" ]
        
    }
    
    @objc
    class func keyPathsForValuesAffectingIsFinished() -> Set<String> {
        
        return [ "operationState" ]
        
    }
    
}

extension ReducerOperation {
    
    var currentState: State { return _state.value }
    
    private var operationState: OperationState {
        
        get { return _operationState.value }
        
        set(newOperationState) {
            
            precondition(
                operationState.canPerformTransition(to: newOperationState),
                "Performing an invalid state transition from \(operationState) to \(newOperationState)."
            )
            
            /// Make sure to call outside of async barrier or will result in deallock.
            willChangeValue(forKey: "operationState")
            
            _operationState.modify { $0 = newOperationState }
            
            /// Make sure to call outside of async barrier or will result in deallock.
            didChangeValue(forKey: "operationState")
            
        }
        
    }
    
}

extension ReducerOperation {
    
    private enum OperationState {
        
        case ready, executing, finished, cancelled
        
        func canPerformTransition(to newState: OperationState) -> Bool {
            
            switch (self, newState) {
                
            case (.ready, .executing): return true
                
            case (.ready, .cancelled): return true
                
            case (.executing, .finished): return true
                
            case (.executing, .cancelled): return false
                
            default: return false
                
            }
            
        }
        
    }
    
}
