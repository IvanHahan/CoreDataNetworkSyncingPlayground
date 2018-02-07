//
//  EmployeeRepository.swift
//  CoreDataNetworkLayer
//
//  Created by Ivan Hahanov on 2/7/18.
//  Copyright © 2018  Ivan Hahanov. All rights reserved.
//

import Foundation
import CoreData
import Promise

struct EmployeeRepository {
    
    private let requestCacher: RequestCacheManager
    private let context: NSManagedObjectContext
    
    init(requestCacher: RequestCacheManager, context: NSManagedObjectContext) {
        self.requestCacher = requestCacher
        self.context = context
    }
    
    func create(_ model: Employee) {
        createLocally(model).then(createRemotely)
    }
    
    private func createRemotely(_ model: Employee, id: URL) {
        requestCacher.cache(FirebaseRequest.employee.create(employee: model,
                                                            localId: id))
    }
    
    private func createLocally(_ model: Employee) -> Promise<(Employee, URL)> {
        return Promise { fulfill, reject in
            self.context.perform {
                do {
                    let managed: EmployeeModel = self.context.new()
                    try self.context.save()
                    fulfill((model, managed.objectID.uriRepresentation().absoluteURL))
                } catch {
                    reject(error)
                }
            }
        }
    }
}
