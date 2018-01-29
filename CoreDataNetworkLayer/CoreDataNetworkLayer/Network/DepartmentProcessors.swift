//
//  DepartmentProcessors.swift
//  CoreDataNetworkLayer
//
//  Created by  Ivan Hahanov on 1/22/18.
//  Copyright © 2018  Ivan Hahanov. All rights reserved.
//

import Foundation
import CoreData

class DepartmentProcessor: ChangeProcessor {
    
    var comlpetion: (() -> ())?
    private let requestCacher: RequestCacheManager
    private let group = DispatchGroup()
    
    init(requestCacher: RequestCacheManager) {
        self.requestCacher = requestCacher
    }
    
    func save(_ models: [Department]) {
        for model in models {
            requestCacher.enqueueCachedSynced(NetworkRequest.department.create(department: model, context: model.managedObjectContext!))
        }
        for model in models {
            establishRelationshipsWithEmployees(model: model)
        }
        self.comlpetion?()
    }
    
    func update(_ models: [Department]) {
        
    }
    
    func delete(_ ids: [String]) {
        
    }
    
    private func establishRelationshipsWithEmployees(model: Department) {
        guard let ids = model.employees?.flatMap({ $0.remoteId }), !ids.isEmpty else { return }
        self.requestCacher.enqueueCached(NetworkRequest.department.establishRelationsWithEmployees(id: model.remoteId!,
                                                                                                   employees: ids))
    }
    
}
    

