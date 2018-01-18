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
    private(set) var isSuspended = true
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func run() {
        guard isSuspended else { return }
        isSuspended = false
        context.perform { [weak self] in
            self?.executeNext()
        }
    }
    
    func stop() {
        isSuspended = true
    }
    
    func enqueue<R: Request>(_ request: R) {
        context.perform {
            request.cache(into: self.context)
            try? self.context.save()
            guard self.isSuspended else { return }
            self.run()
        }
    }
    
    private func executeNext() {
        guard let request = CachedRequest.findOrFetchFirst(in: context), !isSuspended else {
            self.isSuspended = true
            return
        }
        execute(request) { [weak self] in
            self?.context.delete(request)
            try? self?.context.save()
            self?.executeNext()
        }
    }
    
    private func execute<R: Request>(_ request: R, successCompletion: @escaping Closure<Void>) {
        let isSuspended = self.isSuspended
        guard !isSuspended else { return }
        sessionManager.execute(request) { [weak self] result in
            guard !isSuspended else { return }
            if case let .failure(error) = result, (error as? NetworkError) != NetworkError.couldNotParseJSON {
                self?.errorHandler?(error)
                self?.sessionManager.execute(request)
            } else {
                successCompletion(())
            }
        }
    }
}
