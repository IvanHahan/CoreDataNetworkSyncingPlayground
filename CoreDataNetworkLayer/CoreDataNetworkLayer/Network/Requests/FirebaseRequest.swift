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
            
            init(employee: Employee, localId: URL) {
                body = try! JSONEncoder().encode(employee)
                self.localId = localId
            }
            
        }
        
    }
    
    enum department {
        private static let path = "departments.json"
        
        struct create: FirebaseModelSyncRequest {
            
            let path: String = department.path
            let method: Method = .post
            let body: Data?
            let localId: URL
            
            init(department: Department, localId: URL) {
                body = try! JSONEncoder().encode(department)
                self.localId = localId
            }
            
        }
    }
}
