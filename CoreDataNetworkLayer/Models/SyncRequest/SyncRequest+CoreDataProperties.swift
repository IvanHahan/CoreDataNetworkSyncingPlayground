//
//  SyncRequest+CoreDataProperties.swift
//  CoreDataNetworkLayer
//
//  Created by Ivan Hahanov on 1/29/18.
//  Copyright © 2018  Ivan Hahanov. All rights reserved.
//
//

import Foundation
import CoreData


extension SyncRequest {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SyncRequest> {
        return NSFetchRequest<SyncRequest>(entityName: "SyncRequest")
    }

    @NSManaged public var body: Data?
    @NSManaged public var pathOptional: String?
    @NSManaged public var methodString: String?
    @NSManaged public var priorityRaw: Int16
    @NSManaged public var localIdOptional: URL?
}
