//
//  Department+CoreDataClass.swift
//  CoreDataNetworkLayer
//
//  Created by  Ivan Hahanov on 1/15/18.
//  Copyright © 2018  Ivan Hahanov. All rights reserved.
//
//

import Foundation
import CoreData

@objc(DepartmentModel)
final public class DepartmentModel: NSManagedObject, Managed, SyncedModel {
    
    static func insert(name: String, employees: Set<EmployeeModel>, head: EmployeeModel, into context: NSManagedObjectContext) {
        let department: DepartmentModel = context.new()
        department.employees = employees
    }
}
