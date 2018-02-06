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

@objc(Employee)
final public class EmployeeModel: NSManagedObject, Codable, SyncedModel {

    private enum CodingKeys: String, CodingKey {
        case name, position, salary, id = "objectId"
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(position, forKey: .position)
        try container.encode(salary, forKey: .salary)
        try container.encode(remoteId, forKey: .id)
    }
    
    public required init(from decoder: Decoder) throws {
        guard let contextUserInfoKey = CodingUserInfoKey.context,
            let managedObjectContext = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: EmployeeModel.identifier, in: managedObjectContext) else {
                fatalError("Failed to decode \(EmployeeModel.identifier)!")
        }
        super.init(entity: entity, insertInto: managedObjectContext)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        position = try container.decode(String.self, forKey: .position)
        salary = try container.decode(Double.self, forKey: .salary)
        remoteId = try container.decode(String.self, forKey: .id)
    }
    
    public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
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
