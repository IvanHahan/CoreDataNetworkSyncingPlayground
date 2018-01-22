//
//  EmployeeProcessors.swift
//  CoreDataNetworkLayer
//
//  Created by  Ivan Hahanov on 1/22/18.
//  Copyright © 2018  Ivan Hahanov. All rights reserved.
//

import Foundation

enum EmployeeProcessor {
    class Saver: ChangeProcessor {
        var comlpetion: (() -> ())?
        
        private let requestCacher: RequestCacheManager
        private let group = DispatchGroup()
        
        func process(_ models: [Employee], completion: ResultClosure<Employee>? = nil) {
            for model in models {
                group.enter()
                requestCacher.enqueue(NetworkRequest.employee.create(employee: model)) { [weak self] result in
                    switch result {
                    case .success(let employee):
                        model.managedObjectContext?.performChanges {
                            model.remoteId = employee.remoteId
                            self?.group.leave()
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
        
        init(requestCacher: RequestCacheManager) {
            self.requestCacher = requestCacher
        }
    }
    
    class Updater: ChangeProcessor {
        var comlpetion: (() -> ())?
        
        private let requestCacher: RequestCacheManager
        private let group = DispatchGroup()
        
        func process(_ models: [Employee], completion: ResultClosure<Employee>? = nil) {
            for model in models {
                group.enter()
                requestCacher.enqueue(NetworkRequest.employee.create(employee: model)) { [weak self] result in
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
        
        func process(_ models: [Employee], completion: ResultClosure<Employee>? = nil) {
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
