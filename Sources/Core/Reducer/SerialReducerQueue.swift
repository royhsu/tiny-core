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
     
        var currentState = initialState
        
        var finishedOperationIDs = Set<UUID>()
        
        let allOperations: [(id: UUID, operation: Operation)] = reducers.map { reducer in
                
            let id = UUID()
            
            #warning("TODO: [Priority: high] use block operation is incorrect, should replace with a custom aysnc operation.")
            let operation = BlockOperation {
                
                reducer.reduce(currentState) { newState in
                    
                    currentState = newState
                    
                    finishedOperationIDs.insert(id)
                    
                }
                
            }
            
            return (id, operation)
                
        }
        
        let allOperationIDs = Set(allOperations.map { $0.id })
        
        let queue = OperationQueue()
        
        // This makes the queue behaves like a serial queue, so we don't need to worry about race conditions.
        queue.maxConcurrentOperationCount = 1
        
        for operation in allOperations {
            
            let operation = operation.operation
            
            operation.completionBlock = {
                
                let areAllOperationsFinished = (allOperationIDs == finishedOperationIDs)
                
                guard areAllOperationsFinished else { return }
                
                completion(currentState)
                    
            }
            
            queue.addOperation(operation)
            
        }
        
    }
    
}
