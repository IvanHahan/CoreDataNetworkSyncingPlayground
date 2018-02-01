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


extension BackendlessSyncRequest {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BackendlessSyncRequest> {
        return NSFetchRequest<BackendlessSyncRequest>(entityName: "SyncRequest")
    }

    @NSManaged public var request: CachedRequest?
    @NSManaged public var localIdOptional: URL?
}
