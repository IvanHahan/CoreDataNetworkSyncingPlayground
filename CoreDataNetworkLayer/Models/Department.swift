//
//  Department.swift
//  CoreDataNetworkLayer
//
//  Created by Ivan Hahanov on 2/6/18.
//  Copyright © 2018  Ivan Hahanov. All rights reserved.
//

import Foundation

struct Department: Codable {
    var name: String?
    var employees: [String]?
    var head: Employee?
    var id: String?
    
    enum CodingKeys: String, CodingKey {
        case name, employees, head, id = "objectId"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(employees, forKey: .employees)
        try container.encode(head, forKey: .head)
    }
    
}
