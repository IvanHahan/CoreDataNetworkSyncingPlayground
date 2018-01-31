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

@objc(Department)
final public class Department: NSManagedObject, Codable, Managed, SyncedModel {

    private enum CodingKeys: String, CodingKey {
        case name, employees, head, id = "objectId"
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(employees?.flatMap { $0.remoteId }, forKey: .employees)
        try container.encode(head, forKey: .head)
    }
    
    public required init(from decoder: Decoder) throws {
        guard let contextUserInfoKey = CodingUserInfoKey.context,
            let managedObjectContext = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: Department.entity().name!, in: managedObjectContext) else {
                fatalError("Failed to decode \(Employee.identifier)!")
        }
        super.init(entity: entity, insertInto: managedObjectContext)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        employees = try? container.decode(Set<Employee>.self, forKey: .employees)
        head = try? container.decode(Employee.self, forKey: .head)
        remoteId = try container.decode(String.self, forKey: .id)
    }
    
    public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    static func insert(name: String, employees: Set<Employee>, head: Employee, into context: NSManagedObjectContext) {
        let department: Department = context.new()
        department.employees = employees
        department.head = head
    }
}
