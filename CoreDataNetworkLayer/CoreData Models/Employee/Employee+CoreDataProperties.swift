//
//  Employee+CoreDataProperties.swift
//  CoreDataNetworkLayer
//
//  Created by  Ivan Hahanov on 1/15/18.
//  Copyright © 2018  Ivan Hahanov. All rights reserved.
//
//

import Foundation
import CoreData


extension EmployeeModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EmployeeModel> {
        return NSFetchRequest<EmployeeModel>(entityName: "Employee")
    }

    @NSManaged public var name: String?
    @NSManaged public var position: String?
    @NSManaged public var salary: Double
    @NSManaged public var remoteId: String?
}
