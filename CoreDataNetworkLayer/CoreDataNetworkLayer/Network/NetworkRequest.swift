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
        
        struct create: DecodableResultRequest {
            
            typealias Model = Employee
            
            let path: String = employee.path
            let method: Method = .post
            let body: Data?
            
            private let context: NSManagedObjectContext
            
            init(employee: Employee, context: NSManagedObjectContext) {
                self.context = context
                body = try! JSONEncoder().encode(employee)
            }
            
            func map(from data: Data) -> Employee? {
                guard let key = CodingUserInfoKey.context else { return nil }
                let decoder = JSONDecoder()
                decoder.userInfo[key] = context
                return try? decoder.decode(Model.self, from: data)
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
        
        struct create: DecodableResultRequest {
            
            typealias Model = Department
            
            let path: String = department.path
            let method: Method = .post
            let body: Data?
            private let context: NSManagedObjectContext
            
            init(department: Department, context: NSManagedObjectContext) {
                body = try! JSONEncoder().encode(department)
                self.context = context
            }
            
            func map(from data: Data) -> Department? {
                guard let key = CodingUserInfoKey.context else { return nil }
                let decoder = JSONDecoder()
                decoder.userInfo[key] = context
                return try? decoder.decode(Model.self, from: data)
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
            
            init(id: String, employees: [String]) {
                self.id = id
                body = try! JSONEncoder().encode(employees)
            }
        }
    }
}
