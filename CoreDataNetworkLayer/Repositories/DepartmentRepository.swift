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
    
    private let requestCacher: RequestCacheManager
    private let context: NSManagedObjectContext
    
    init(requestCacher: RequestCacheManager, context: NSManagedObjectContext) {
        self.requestCacher = requestCacher
        self.context = context
    }
    
    func create(_ model: Department) -> Promise<Void> {
        return createLocally(model).then(createRemotely)
    }
    
    func get() -> Promise<[Department]> {
        return Promise(queue: DispatchQueue.global(qos: .background)) { fulfill, reject in
            do {
                let fetched = try self.context.fetch(DepartmentModel.fetchRequest(configured: {$0.includesPropertyValues = true}))
                let mapped = fetched.map { (managed) -> Department in
                    var model = Department()
                    model.name = managed.name
                    model.id = managed.remoteId
                    return model
                }
                fulfill(mapped)
            } catch {
                reject(error)
            }
        }
    }
    
    private func createRemotely(_ model: Department, localId: URL) -> Promise<Void> {
        requestCacher.cache(FirebaseRequest.department.create(department: model,
                                                              localId: localId))
        return Promise(value: ())
    }
    
    private func createLocally(_ model: Department) -> Promise<(Department, URL)> {
        return Promise(queue: DispatchQueue.global(qos: .background)) { fulfill, reject in
            self.context.perform {
                do {
                    let managed: DepartmentModel = self.context.new()
                    managed.name = model.name
                    model.employees.flatMap {
                        managed.employees = Set($0.map { emp in
                            let empManaged: EmployeeModel = self.context.new()
                            empManaged.name = emp.name
                            empManaged.remoteId = emp.id
                            empManaged.salary = emp.salary
                            return empManaged
                        })
                    }
                    try self.context.save()
                    fulfill((model, managed.objectID.uriRepresentation().absoluteURL))
                } catch {
                    print(error.localizedDescription)
                    reject(error)
                }
            }
        }
    }
}
