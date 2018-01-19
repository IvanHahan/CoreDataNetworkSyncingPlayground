//
//  NetworkRequest.swift
//  CoreDataNetworkLayer
//
//  Created by  Ivan Hahanov on 1/16/18.
//  Copyright © 2018  Ivan Hahanov. All rights reserved.
//

import Foundation

enum NetworkRequest {
    enum employee {
        
        private static let path = "data/Employee"
        
        struct create: Request {
            
            typealias Model = Void
            
            let path: String = employee.path
            let method: Method = .post
            let body: Data?
            
            init(employee: Employee) {
                body = try! JSONEncoder().encode(employee)
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
        }
    }
    
    enum department {
        private static let path = "data/Department"
        
        struct create: Request {
            
            typealias Model = Department
            
            let path: String = department.path
            let method: Method = .post
            let body: Data?
            
            init(department: Department) {
                body = try! JSONEncoder().encode(department)
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
            
            private let id: String
            
            init(id: String, department: Department) {
                self.id = id
                body = try! JSONEncoder().encode(department)
            }
        }
    }
}
