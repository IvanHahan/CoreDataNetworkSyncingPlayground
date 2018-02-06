//
//  Repository.swift
//  CoreDataNetworkLayer
//
//  Created by Ivan Hahanov on 2/6/18.
//  Copyright © 2018  Ivan Hahanov. All rights reserved.
//

import Foundation
import CoreData
import Promise

struct DepartmentRepository {
    
    private let sessionManager: SessionManager
    private let context: NSManagedObjectContext
    
    init(sessionManager: SessionManager, context: NSManagedObjectContext) {
        self.sessionManager = sessionManager
        self.context = context
    }
    
    func create(_ model: Department) -> Promise<Void> {
        return createLocally(model).then(createRemotely)
    }
    
    private func createRemotely(_ model: DepartmentModel) -> Promise<Void> {
        return sessionManager.execute(FirebaseRequest.department.create(department: model,
                                                                        context: model.managedObjectContext!)).result.then { id in
                                                                            
        }
    }
    
    private func createLocally(_ model: Department) -> Promise<DepartmentModel> {
        return Promise { fulfill, reject in
            self.context.perform {
                do {
                    let managed: DepartmentModel = self.context.new()
                    try self.context.save()
                    fulfill(managed)
                } catch {
                    reject(error)
                }
            }
        }
    }
}
