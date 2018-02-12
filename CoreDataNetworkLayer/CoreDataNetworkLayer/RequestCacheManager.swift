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
    private let sessionManager: SessionManager
    var completion: Closure<Void>?
    
    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext
    private let syncContext: NSManagedObjectContext
    private(set) var isExecuting: Bool = false
    
    init(sessionManager: SessionManager, context: NSManagedObjectContext, domainContainer: NSPersistentContainer) {
        self.sessionManager = sessionManager
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
        if let request = CachedRequest.findOrFetchFirst(in: context) {
            sessionManager.execute(request).then { [weak self] result in
                self?.context.delete(request)
                try? self?.context.save()
                Notification
                }.always { [weak self] in
                    self?.executeNext()
            }
        } else {
            isExecuting = false
        }
    }
}
