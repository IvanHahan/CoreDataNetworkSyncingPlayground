//
//  RequestOperation.swift
//  CoreDataNetworkLayer
//
//  Created by  Ivan Hahanov on 1/19/18.
//  Copyright © 2018  Ivan Hahanov. All rights reserved.
//

import Foundation

class RequestOperation<Resource: Request>: Operation {
    
    typealias ConditionBlock = () -> Bool
    
    enum State {
        case pending, executing, cancelled, finished
    }
    
    private let request: Resource
    private let service: SessionManager
    private var completion: ResultClosure<Resource.Model>?
    var conditions: [ConditionBlock] = []
    
    override var isFinished: Bool {
        return service.state == .finished
    }
    
    override var isExecuting: Bool {
        return service.state == .executing
    }
    
    override var isCancelled: Bool {
        return service.state == .cancelled
    }
    
    init(request: Resource,
         service: SessionManager,
         completion: ResultClosure<Resource.Model>? = nil) {
        self.request = request
        self.service = service
        self.completion = completion
        super.init()
        self.service.didChangeState = { [unowned self] _ in
            self.willChangeValue(forKey: "isFinished")
            self.willChangeValue(forKey: "isExecuting")
            self.willChangeValue(forKey: "isCancelled")
            self.didChangeValue(forKey: "isFinished")
            self.didChangeValue(forKey: "isExecuting")
            self.didChangeValue(forKey: "isCancelled")
        }
    }
    
    override func main() {
        if verifyConditions() == false {
            return
        }
        if !self.isCancelled {
            execute()
        }
    }
    
    override func cancel() {
        service.cancel()
    }
    
    private func verifyConditions() -> Bool {
        for condition in conditions {
            if isCancelled {
                return false
            }
            if condition() != true {
                return false
            }
        }
        return true
    }
    
    func execute() {
        if !self.isCancelled {
            service.execute(request) { model in
                DispatchQueue.main.async {
                    self.completion?(model)
                }
            }
        }
    }
}
