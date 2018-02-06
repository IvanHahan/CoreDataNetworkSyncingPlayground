//
//  Department+CoreDataProperties.swift
//  CoreDataNetworkLayer
//
//  Created by  Ivan Hahanov on 1/15/18.
//  Copyright © 2018  Ivan Hahanov. All rights reserved.
//
//

import Foundation
import CoreData


extension DepartmentModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DepartmentModel> {
        return NSFetchRequest<DepartmentModel>(entityName: "Department")
    }

    @NSManaged public var name: String?
    @NSManaged public var employees: Set<EmployeeModel>?
    @NSManaged public var head: EmployeeModel?
    @NSManaged public var remoteId: String?
    @NSManaged public var employeeRemoteIds: [String: Bool]?

}

// MARK: Generated accessors for employees
extension DepartmentModel {

    @objc(insertObject:inEmployeesAtIndex:)
    @NSManaged public func insertIntoEmployees(_ value: EmployeeModel, at idx: Int)

    @objc(removeObjectFromEmployeesAtIndex:)
    @NSManaged public func removeFromEmployees(at idx: Int)

    @objc(insertEmployees:atIndexes:)
    @NSManaged public func insertIntoEmployees(_ values: [EmployeeModel], at indexes: NSIndexSet)

    @objc(removeEmployeesAtIndexes:)
    @NSManaged public func removeFromEmployees(at indexes: NSIndexSet)

    @objc(replaceObjectInEmployeesAtIndex:withObject:)
    @NSManaged public func replaceEmployees(at idx: Int, with value: EmployeeModel)

    @objc(replaceEmployeesAtIndexes:withEmployees:)
    @NSManaged public func replaceEmployees(at indexes: NSIndexSet, with values: [EmployeeModel])

    @objc(addEmployeesObject:)
    @NSManaged public func addToEmployees(_ value: EmployeeModel)

    @objc(removeEmployeesObject:)
    @NSManaged public func removeFromEmployees(_ value: EmployeeModel)

    @objc(addEmployees:)
    @NSManaged public func addToEmployees(_ values: NSOrderedSet)

    @objc(removeEmployees:)
    @NSManaged public func removeFromEmployees(_ values: NSOrderedSet)

}
