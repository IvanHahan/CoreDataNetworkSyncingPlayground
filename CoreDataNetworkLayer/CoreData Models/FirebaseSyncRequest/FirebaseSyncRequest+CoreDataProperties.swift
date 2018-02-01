//
//  FirebaseSyncRequest+CoreDataProperties.swift
//  CoreDataNetworkLayer
//
//  Created by Ivan Hahanov on 1/31/18.
//  Copyright © 2018  Ivan Hahanov. All rights reserved.
//
//

import Foundation
import CoreData


extension FirebaseSyncRequest {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FirebaseSyncRequest> {
        return NSFetchRequest<FirebaseSyncRequest>(entityName: "FirebaseSyncRequest")
    }

    @NSManaged public var request: CachedRequest?
    @NSManaged public var localIdOptional: URL?
}

extension FirebaseSyncRequest: FirebaseModelSyncRequest {
    
    var method: Method { return Method(rawValue: request!.methodString!)! }
    var priority: Priority { return Priority(rawValue: request!.priorityRaw)! }
    var path: String { return request!.pathOptional! }
    var body: Data? { return request?.body }
    var localId: URL { return localIdOptional! }
}
