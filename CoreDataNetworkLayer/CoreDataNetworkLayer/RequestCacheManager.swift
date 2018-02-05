//
//  RequestCacheManager.swift
//  CoreDataNetworkLayer
//
//  Created by  Ivan Hahanov on 1/17/18.
//  Copyright © 2018  Ivan Hahanov. All rights reserved.
//

import Foundation
import CoreData

class RequestCacheManager {
    
    var errorHandler: Closure<Error>?
    var syncCompletion: Closure<Void>?
    private let sessionManager: SessionManager
    
    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext
    private let syncContext: NSManagedObjectContext
    private(set) var isExecuting: Bool = false
    
    init(environment: Environment, context: NSManagedObjectContext, domainContainer: NSPersistentContainer) {
        self.sessionManager = SessionManager(baseUrl: environment.baseUrl, config: URLSessionConfiguration.default)
        self.container = domainContainer
        self.context = context
        self.syncContext = domainContainer.newBackgroundContext()
    }
    
    func run() {
        guard !self.isExecuting else { return }
        self.isExecuting = true
        context.perform {
            self.executeNext()
        }
    }
    
    func stop() {
        self.isExecuting = false
    }
    
    func cache<R: Request>(_ request: R) {
        context.perform {
            request.cache(into: self.context)
            try? self.context.save()
            self.run()
        }
    }
    
    private func executeNext() {
        guard isExecuting else { return }
        if let request = FirebaseSyncRequest.findOrFetchFirst(in: context) {
            sessionManager.execute(request) { [weak self] result in
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
            sessionManager.execute(request) { [weak self] result in
                switch result {
                case .success:
                    self?.context.delete(request)
                    try? self?.context.save()
                default:()
                }
                self?.executeNext()
            }
        } else {
            isExecuting = false
            syncCompletion?(())
        }
    }
}
