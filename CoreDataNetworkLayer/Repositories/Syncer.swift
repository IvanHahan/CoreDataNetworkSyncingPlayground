//
//  Syncer.swift
//  CoreDataNetworkLayer
//
//  Created by Ivan Hahanov on 2/14/18.
//  Copyright © 2018  Ivan Hahanov. All rights reserved.
//

import Foundation
import CoreData

protocol Syncer {
    
    var context: NSManagedObjectContext { get }
    var container: NSPersistentContainer { get }
    
    func syncLocally(with data: Data)
}

extension Syncer {
    func syncLocally(with object: Any) {
        guard let data = object as? Data,
            let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
            let localId = json?["localId"] as? String,
            let remoteId = json?["remoteId"] as? String,
            let localIdUrl = URL(string: localId),
            let managedObjectId = container.managedObjectID(from: localIdUrl),
            let managedObject = context.object(with: managedObjectId) as? SyncedModel else { return }
        context.performChanges {
            managedObject.remoteId = remoteId
        }
    }
}
