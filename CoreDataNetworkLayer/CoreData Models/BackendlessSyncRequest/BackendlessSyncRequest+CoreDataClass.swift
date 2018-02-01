//
//  SyncRequest+CoreDataClass.swift
//  CoreDataNetworkLayer
//
//  Created by Ivan Hahanov on 1/29/18.
//  Copyright © 2018  Ivan Hahanov. All rights reserved.
//
//

import Foundation
import CoreData

@objc(SyncRequest)
final public class BackendlessSyncRequest: NSManagedObject, Managed {
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [
            NSSortDescriptor(key: #keyPath(request.priorityRaw), ascending: false)
        ]
    }
}

extension BackendlessSyncRequest: BackendlessModelSyncRequest {
    
    var method: Method { return Method(rawValue: request!.methodString!)! }
    var priority: Priority { return Priority(rawValue: request!.priorityRaw)! }
    var path: String { return request!.pathOptional! }
    var localId: URL { return localIdOptional! }
    var body: Data? { return request?.body }
}
