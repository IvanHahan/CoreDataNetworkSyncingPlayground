//
//  FirebaseRequest.swift
//  CoreDataNetworkLayer
//
//  Created by Ivan Hahanov on 1/31/18.
//  Copyright © 2018  Ivan Hahanov. All rights reserved.
//

import Foundation
import CoreData

enum FirebaseRequest {
    enum employee {
        
        private static let path = "employees.json"
        
        struct create: FirebaseModelSyncRequest {
            
            let path: String = employee.path
            let method: Method = .post
            let body: Data?
            var priority: Priority { return .high }
            let localId: URL
            
            private let context: NSManagedObjectContext
            
            init(employee: Employee, context: NSManagedObjectContext) {
                self.context = context
                body = try! JSONEncoder().encode(employee)
                self.localId = employee.objectID.uriRepresentation().absoluteURL
            }
            
        }
        
    }
    
    enum department {
        private static let path = "departments.json"
        
        struct create: FirebaseModelSyncRequest {
            
            let path: String = department.path
            let method: Method = .post
            let body: Data?
            private let context: NSManagedObjectContext
            let localId: URL
            
            init(department: DepartmentModel, context: NSManagedObjectContext) {
                body = try! JSONEncoder().encode(department)
                self.context = context
                self.localId = department.objectID.uriRepresentation().absoluteURL
            }
            
        }
    }
}
