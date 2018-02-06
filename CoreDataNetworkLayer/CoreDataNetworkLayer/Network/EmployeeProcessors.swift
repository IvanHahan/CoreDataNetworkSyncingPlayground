//
//  EmployeeProcessors.swift
//  CoreDataNetworkLayer
//
//  Created by  Ivan Hahanov on 1/22/18.
//  Copyright © 2018  Ivan Hahanov. All rights reserved.
//

import Foundation
import CoreData

class EmployeeProcessor: ChangeProcessor {
    
    var comlpetion: Closure<Void>?
    private let requestCacher: RequestCacheManager
    private let group = DispatchGroup()
    
    init(requestCacher: RequestCacheManager) {
        self.requestCacher = requestCacher
    }
    
    func save(_ models: [EmployeeModel]) {
        for model in models {
            requestCacher.cache(FirebaseRequest.employee.create(employee: model, context: model.managedObjectContext!))
        }
        self.comlpetion?(())
    }
    
    func update(_ models: [EmployeeModel]) {
        
    }
    
    func delete(_ ids: [String]) {
        
    }
}
