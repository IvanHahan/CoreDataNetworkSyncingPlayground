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
    
    func save(_ models: [DepartmentModel]) {
        for model in models {
            requestCacher.syncCompletion = { [weak self] _ in
                model.managedObjectContext?.refresh(model, mergeChanges: true)
                self?.requestCacher.cache(FirebaseRequest.department.create(department: model, context: model.managedObjectContext!))
                self?.requestCacher.syncCompletion = nil
            }
        }
        self.comlpetion?()
    }
    
    func update(_ models: [DepartmentModel]) {
        
    }
    
    func delete(_ ids: [String]) {
        
    }
    
    private func establishRelationshipsWithEmployees(model: DepartmentModel) {
        guard let ids = model.employees?.flatMap({ $0.remoteId }), !ids.isEmpty else { return }
        self.requestCacher.cache(BackendlessRequest.department.establishRelationsWithEmployees(id: model.remoteId!,
                                                                                                   employees: ids))
        self.requestCacher.syncCompletion = nil
    }
    
}
    

