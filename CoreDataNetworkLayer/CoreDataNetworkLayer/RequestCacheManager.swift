//
//  RequestCacheManager.swift
//  CoreDataNetworkLayer
//
//  Created by  Ivan Hahanov on 1/17/18.
//  Copyright © 2018  Ivan Hahanov. All rights reserved.
//

import Foundation
import CoreData

let baseUrl = "https://com.example.blat/"

class RequestCacheManager {
    
    private let context: NSManagedObjectContext
    private let sessionManager = SessionManager(baseUrl: baseUrl, config: URLSessionConfiguration.default)
    private var isSuspended = false
    var errorHandler: Closure<Error>?
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func run() {
        isSuspended = false
        context.perform { [weak self] in
            self?.executeNext()
        }
    }
    
    func stop() {
        isSuspended = true
    }
    
    func enqueue<R: DecodableResultRequest>(_ request: R) {
        context.performChanges {
            request.cache(into: self.context)
            self.run()
        }
    }
    
    private func executeNext() {
        guard let request = CachedRequest.findOrFetchFirst(in: context), !isSuspended else { return }
        execute(request) { [weak self] in
            self?.context.delete(request)
            self?.executeNext()
        }
    }
    
    private func execute<R: Request>(_ request: R, successCompletion: @escaping Closure<Void>) {
        let isSuspended = self.isSuspended
        guard !isSuspended else { return }
        sessionManager.execute(request) { [weak self] result in
            guard !isSuspended else { return }
            if case let .failure(error) = result {
                self?.errorHandler?(error)
                self?.sessionManager.execute(request)
            } else {
                successCompletion(())
            }
        }
    }
}
