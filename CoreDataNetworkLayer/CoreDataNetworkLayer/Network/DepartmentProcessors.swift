//
//  DepartmentProcessors.swift
//  CoreDataNetworkLayer
//
//  Created by  Ivan Hahanov on 1/22/18.
//  Copyright © 2018  Ivan Hahanov. All rights reserved.
//

import Foundation
import CoreData

enum DepartmentProcessor {
    class Saver: ChangeProcessor {
        var comlpetion: (() -> ())?
        
        private let requestCacher: RequestCacheManager
        private let group = DispatchGroup()
        
        func process(_ models: [Department], context: NSManagedObjectContext, completion: ResultClosure<Department>? = nil) {
            for model in models {
                group.enter()
                requestCacher.enqueue(NetworkRequest.department.create(department: model, context: model.managedObjectContext!)) { [weak self] result in
                    self?.group.leave()
                    switch result {
                    case .success(let department):
                        let mapped = model.remap(to: context)
                        context.performChanges {
                            model.remoteId = department.remoteId
                            self?.establishRelationshipsWithEmployees(model: model)
                        }
                    case .failure(let error):
                        break
                    }
                    completion?(result)
                }
            }
            group.notify(queue: .main) {
                self.comlpetion?()
            }
        }
        
        private func establishRelationshipsWithEmployees(model: Department) {
            guard let ids = model.employees?.flatMap({ $0.remoteId }), !ids.isEmpty else { return }
            self.requestCacher.enqueue(NetworkRequest.department.establishRelationsWithEmployees(id: model.remoteId!,
                                                                                                 employees: ids),
                                       shouldCache: true)
        }
        
        init(requestCacher: RequestCacheManager) {
            self.requestCacher = requestCacher
        }
    }
    
    class Updater: ChangeProcessor {
        var comlpetion: (() -> ())?
        
        private let requestCacher: RequestCacheManager
        private let group = DispatchGroup()
        
        func process(_ models: [Department], context: NSManagedObjectContext, completion: ResultClosure<Department>? = nil) {
            for model in models {
                group.enter()
                requestCacher.enqueue(NetworkRequest.department.update(id: model.remoteId!, department: model)) { [weak self] result in
                    self?.group.leave()
                    completion?(result)
                }
            }
            group.notify(queue: .main) {
                self.comlpetion?()
            }
        }
        
        init(requestCacher: RequestCacheManager) {
            self.requestCacher = requestCacher
        }
    }
    
    class Remover: ChangeProcessor {
        var comlpetion: (() -> ())?
        
        private let requestCacher: RequestCacheManager
        private let group = DispatchGroup()
        
        func process(_ models: [Employee], context: NSManagedObjectContext, completion: ResultClosure<Employee>? = nil) {
            for model in models {
                group.enter()
                requestCacher.enqueue(NetworkRequest.employee.delete(employeeId: model.remoteId!)) { [weak self] result in
                    self?.group.leave()
                    completion?(result)
                }
            }
            group.notify(queue: .main) {
                self.comlpetion?()
            }
        }
        
        init(requestCacher: RequestCacheManager) {
            self.requestCacher = requestCacher
        }
    }
}
