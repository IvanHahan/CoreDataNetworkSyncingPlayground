//
//  NetworkRequest.swift
//  CoreDataNetworkLayer
//
//  Created by  Ivan Hahanov on 1/16/18.
//  Copyright © 2018  Ivan Hahanov. All rights reserved.
//

import Foundation
import CoreData

enum NetworkRequest {
    enum employee {
        
        private static let path = "data/Employee"
        
        struct create: ModelSyncRequest {
            
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
        
        struct update: DecodableResultRequest {
            
            typealias Model = Employee
            
            let path: String = ""
            let method: Method = .put
            let body: Data?
        }
        
        struct get: DecodableResultRequest {
            
            typealias Model = Employee
            
            let path: String = ""
        }
        
        struct delete: DecodableResultRequest {            
            
            typealias Model = Employee
            
            let path: String = ""
            let method: Method = .delete
            
            init(employeeId id: String) {
                
            }
        }
    }
    
    enum department {
        private static let path = "data/Department"
        
        struct create: ModelSyncRequest {
            
            let path: String = department.path
            let method: Method = .post
            let body: Data?
            private let context: NSManagedObjectContext
            let localId: URL
            
            init(department: Department, context: NSManagedObjectContext) {
                body = try! JSONEncoder().encode(department)
                self.context = context
                self.localId = department.objectID.uriRepresentation().absoluteURL
            }

        }
        
        struct update: DecodableResultRequest {
            
            typealias Model = Department
            
            var path: String { return department.path + "\(id)" }
            let method: Method = .post
            let body: Data?
            
            private let id: String
            
            init(id: String, department: Department) {
                self.id = id
                body = try! JSONEncoder().encode(department)
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
        }
    }
}
