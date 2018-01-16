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
final public class Department: NSManagedObject, Codable {

    private enum CodingKeys: String, CodingKey {
        case name, employees, head
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(employees, forKey: .name)
        try container.encode(head, forKey: .head)
    }
    
    public required init(from decoder: Decoder) throws {
        guard let contextUserInfoKey = CodingUserInfoKey.context,
            let managedObjectContext = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: Department.identifier, in: managedObjectContext) else {
                fatalError("Failed to decode \(Employee.identifier)!")
        }
        super.init(entity: entity, insertInto: nil)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        employees = try container.decode(NSOrderedSet?.self, forKey: .employees)
        head = try container.decode(Employee.self, forKey: .head)
    }
}
