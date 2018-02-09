//
//  Employee+CoreDataClass.swift
//  CoreDataNetworkLayer
//
//  Created by  Ivan Hahanov on 1/15/18.
//  Copyright © 2018  Ivan Hahanov. All rights reserved.
//
//

import Foundation
import CoreData

@objc(EmployeeModel)
final public class EmployeeModel: EncodableModel, SyncedModel {

    @discardableResult
    static func insert(name: String, position: String, salary: Double, department: DepartmentModel, into context: NSManagedObjectContext) -> EmployeeModel {
        let employee: EmployeeModel = context.new()
        employee.name = name
        employee.position = position
        employee.salary = salary
        department.employees?.insert(employee)
        return employee
    }
}

extension EmployeeModel: Managed {
    
    static var sortDescriptors: [NSSortDescriptor] {
        return [
            NSSortDescriptor(key: #keyPath(name), ascending: true)
        ]
    }
    
    static func predicate(for department: DepartmentModel) -> NSPredicate {
        return NSPredicate(format: "department == %@", department)
    }
}

extension CodingUserInfoKey {
    static let context = CodingUserInfoKey(rawValue: "context")
}
