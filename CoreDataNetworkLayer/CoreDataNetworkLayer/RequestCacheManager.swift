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
    var syncCompletion: Closure<Void>?
    let sessionManager = SessionManager(baseUrl: baseUrl, config: URLSessionConfiguration.default)
    var isSuspended: Bool {
        return queue.isSuspended
    }
    
    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext
    private let syncContext: NSManagedObjectContext
    private(set) var isRunningCached: Bool = false
    private let queue = OperationQueue()
    
    init(context: NSManagedObjectContext, domainContainer: NSPersistentContainer) {
        self.container = domainContainer
        self.context = context
        self.syncContext = domainContainer.newBackgroundContext()
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
    
    func synchronize<R>(_ operations: [RequestOperation<R>], completion: @escaping Closure<Void>) {
        stop()
        let completionOperation = BlockOperation { completion(()) }
        operations.forEach {
            completionOperation.addDependency($0)
            queue.addOperation($0)
        }
        queue.addOperation(completionOperation)
        run()
    }
    
    @discardableResult
    func enqueueSecured<R: Request>(_ request: R, completion: Closure<R.Model>? = nil) -> Operation {
        return enqueue(request) { [weak self] result in
            switch result {
            case .success(let model):
                completion?(model)
            case .failure:
                self?.enqueueSecured(request, completion: completion)
            }
        }
    }
    
    func operation<R>(_ request: R, completion: ResultClosure<R.Model>? = nil) -> RequestOperation<R> {
        return RequestOperation(request: request, service: sessionManager, completion: completion)
    }
    
    @discardableResult
    func enqueue<R: Request>(_ request: R, completion: ResultClosure<R.Model>? = nil) -> Operation {
        let operation = self.operation(request, completion: completion)
        self.queue.addOperation(operation)
        return operation
    }
    
    func enqueueCachedSynced<R: ModelSyncRequest>(_ request: R) {
        context.perform {
            request.cacheSynced(into: self.context)
            try? self.context.save()
            guard !self.isRunningCached else { return }
            self.isRunningCached = true
            self.executeNext()
        }
    }
    
    func enqueueCached<R: Request>(_ request: R) {
        context.perform {
            request.cache(into: self.context)
            try? self.context.save()
            guard !self.isRunningCached else { return }
            self.isRunningCached = true
            self.executeNext()
        }
    }
    
    private func executeNext() {
        if let request = SyncRequest.findOrFetchFirst(in: context) {
            enqueue(request) { [weak self] result in
                switch result {
                case .success(let remoteId):
                    guard let localId = request.localIdOptional,
                        let managedObjectId = self?.container.managedObjectID(from: localId),
                        let object = self?.syncContext.object(with: managedObjectId) as? SyncedModel else { return }

                    object.remoteId = remoteId
                    self?.syncContext.saveOrRollback()
                    self?.context.delete(request)
                    self?.context.saveOrRollback()
                    self?.executeNext()
                case .failure:
                    self?.executeNext()
                }
            }
        } else if let request = CachedRequest.findOrFetchFirst(in: context) {
            enqueue(request) { [weak self] result in
                switch result {
                case .success:
                    self?.context.delete(request)
                    try? self?.context.save()
                default:()
                }
                self?.executeNext()
            }
        } else {
            isRunningCached = false
            syncCompletion?(())
        }
    }
}
