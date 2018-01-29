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
final public class SyncRequest: NSManagedObject, Managed {
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [
            NSSortDescriptor(key: #keyPath(priorityRaw), ascending: false)
        ]
    }
}

extension SyncRequest: ModelSyncRequest {    
    
    var method: Method { return Method(rawValue: methodString!)! }
    var priority: Priority { return Priority(rawValue: priorityRaw)! }
    var path: String { return pathOptional! }
    var localId: URL { return localIdOptional! }
}
