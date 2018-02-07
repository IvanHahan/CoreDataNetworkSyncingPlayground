//
//  NetworkRequest.swift
//  CoreDataNetworkLayer
//
//  Created by  Ivan Hahanov on 1/16/18.
//  Copyright © 2018  Ivan Hahanov. All rights reserved.
//

import Foundation
import CoreData

enum BackendlessRequest {
    enum employee {
        
        private static let path = "data/Employee"
        
        struct create: BackendlessModelSyncRequest {
            
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
        private static let path = "data/Department"
        
        struct create: BackendlessModelSyncRequest {
            
            let path: String = department.path
            let method: Method = .post
            let body: Data?
            let localId: URL
            
            init(department: Department, localId: URL) {
                body = try! JSONEncoder().encode(department)
                self.localId = localId
            }

        }
        
        struct establishRelationsWithEmployees: Request {
            typealias Model = Void
            
            var path: String { return department.path.appending("/\(id)/employees") }
            let method: Method = .post
            let body: Data?
            var priority: Priority { return .low }
            
            private let id: String
            
            init(id: String, employees: [String]) {
                self.id = id
                body = try! JSONEncoder().encode(employees)
            }
            
            func map(from data: Data) -> Void? {
                return ()
            }
        }
    }
}
