//
//  RequestCacheManager.swift
//  CoreDataNetworkLayer
//
//  Created by  Ivan Hahanov on 1/17/18.
//  Copyright © 2018  Ivan Hahanov. All rights reserved.
//

import Foundation
import CoreData

let baseUrl = "https://api.backendless.com/50F43BB7-8B2B-0509-FF7B-3665F066E500/7D915167-68FB-B6C8-FF9D-2EE480B58F00/"

class RequestCacheManager {
    
    var errorHandler: Closure<Error>?
    var completion: Closure<Void>?
    let sessionManager = SessionManager(baseUrl: baseUrl, config: URLSessionConfiguration.default)
    
    private let context: NSManagedObjectContext
    var isSuspended: Bool {
        return queue.isSuspended
    }
    private let queue = OperationQueue()
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func run() {
        queue.isSuspended = false
    }
    
    func runCached() {
        queue.isSuspended = false
        context.perform { [weak self] in
            self?.executeNext()
        }
    }
    
    func stop() {
        queue.isSuspended = true
    }
    
    func enqueueSecured<R: Request>(_ request: R, completion: Closure<R.Model>? = nil) {
        enqueue(request) { [weak self] result in
            switch result {
            case .success(let model):
                completion?(model)
            case .failure:
                self?.enqueue(request)
            }
        }
    }
    
    func enqueue<R: Request>(_ request: R, completion: ResultClosure<R.Model>? = nil) {
        let operation = RequestOperation(request: request, service: sessionManager, completion: completion)
        queue.addOperation(operation)
    }
    
    func enqueueCached<R: Request>(_ request: R) {
        context.perform {
            request.cache(into: self.context)
            try? self.context.save()
            self.runCached()
        }
    }
    
    private func executeNext() {
        guard let request = CachedRequest.findOrFetchFirst(in: context) else { return }
        enqueue(request) { [weak self] result in
            self?.context.delete(request)
            try? self?.context.save()
            self?.executeNext()
        }
    }
}
