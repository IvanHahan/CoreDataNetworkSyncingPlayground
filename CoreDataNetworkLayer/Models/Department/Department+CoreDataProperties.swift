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


extension Department {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Department> {
        return NSFetchRequest<Department>(entityName: "Department")
    }

    @NSManaged public var name: String?
    @NSManaged public var employees: Set<Employee>?
    @NSManaged public var head: Employee?
    @NSManaged public var id: String?

}

// MARK: Generated accessors for employees
extension Department {

    @objc(insertObject:inEmployeesAtIndex:)
    @NSManaged public func insertIntoEmployees(_ value: Employee, at idx: Int)

    @objc(removeObjectFromEmployeesAtIndex:)
    @NSManaged public func removeFromEmployees(at idx: Int)

    @objc(insertEmployees:atIndexes:)
    @NSManaged public func insertIntoEmployees(_ values: [Employee], at indexes: NSIndexSet)

    @objc(removeEmployeesAtIndexes:)
    @NSManaged public func removeFromEmployees(at indexes: NSIndexSet)

    @objc(replaceObjectInEmployeesAtIndex:withObject:)
    @NSManaged public func replaceEmployees(at idx: Int, with value: Employee)

    @objc(replaceEmployeesAtIndexes:withEmployees:)
    @NSManaged public func replaceEmployees(at indexes: NSIndexSet, with values: [Employee])

    @objc(addEmployeesObject:)
    @NSManaged public func addToEmployees(_ value: Employee)

    @objc(removeEmployeesObject:)
    @NSManaged public func removeFromEmployees(_ value: Employee)

    @objc(addEmployees:)
    @NSManaged public func addToEmployees(_ values: NSOrderedSet)

    @objc(removeEmployees:)
    @NSManaged public func removeFromEmployees(_ values: NSOrderedSet)

}
