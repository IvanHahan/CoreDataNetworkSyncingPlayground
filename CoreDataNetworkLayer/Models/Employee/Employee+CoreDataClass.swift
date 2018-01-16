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
final public class Employee: NSManagedObject, Codable {

    private enum CodingKeys: String, CodingKey {
        case name, position, salary
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
    }
    
    public required init(from decoder: Decoder) throws {
        guard let contextUserInfoKey = CodingUserInfoKey.context,
            let managedObjectContext = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: Employee.identifier, in: managedObjectContext) else {
                fatalError("Failed to decode \(Employee.identifier)!")
        }
        super.init(entity: entity, insertInto: nil)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        position = try container.decode(String.self, forKey: .position)
        salary = try container.decode(Double.self, forKey: .salary)
    }
    
    public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    @discardableResult
    static func insert(name: String, position: String, salary: Double, into context: NSManagedObjectContext) -> Employee {
        let employee: Employee = context.new()
        employee.name = name
        employee.position = position
        employee.salary = salary
        return employee
    }
}

extension Employee: Managed {
    
    var sortDescriptors: [NSSortDescriptor] {
        return [
            NSSortDescriptor(key: #keyPath(name), ascending: true)
        ]
    }
}

extension CodingUserInfoKey {
    static let context = CodingUserInfoKey(rawValue: "context")
}
