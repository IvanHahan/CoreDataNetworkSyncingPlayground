//
//  Employee.swift
//  CoreDataNetworkLayer
//
//  Created by Ivan Hahanov on 2/6/18.
//  Copyright © 2018  Ivan Hahanov. All rights reserved.
//

import Foundation

struct Employee: Codable {
    
    private enum CodingKeys: String, CodingKey {
        case name, position, salary, id = "objectId"
    }
    
    var name: String
    var position: String
    var salary: Double
    var id: String?
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(position, forKey: .position)
        try container.encode(salary, forKey: .salary)
        try container.encode(id, forKey: .id)
    }
}
