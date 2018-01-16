//
//  DataController.swift
//  CoreDataNetworkLayer
//
//  Created by  Ivan Hahanov on 1/15/18.
//  Copyright © 2018  Ivan Hahanov. All rights reserved.
//

import Foundation
import CoreData

class DataController {
    
    let container: NSPersistentContainer
    private let sessionManager: SessionManager = SessionManager(baseUrl: "", config: URLSessionConfiguration.default)
    
    private var insertedObjects = Set<NSManagedObject>()
    
    init(completion: Closure<Void>? = nil) {
        container = NSPersistentContainer(name: "Company")
        container.loadPersistentStores { (store, error) in
            if error != nil {
                fatalError("Could not load persistent store")
            }
            completion?(())
        }
//        NotificationCenter.default.addObserver(forName: Notification.Name.NSManagedObjectContextObjectsDidChange,
//                                               object: nil,
//                                               queue: nil) { note in
//                                                guard let context = note.object as? NSManagedObjectContext else { return }
//                                                insertedObjects = context.insertedObjects
//        }
//        NotificationCenter.default.addObserver(forName: Notification.Name.NSManagedObjectContextDidSave,
//                                               object: nil,
//                                               queue: nil) { note in
//                                                <#code#>
//        }
    }

}
