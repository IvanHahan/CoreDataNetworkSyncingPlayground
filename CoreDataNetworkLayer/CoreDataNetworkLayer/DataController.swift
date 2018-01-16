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
    private let sessionManager: SessionManager = SessionManager(baseUrl: "https://com.example.blat/", config: URLSessionConfiguration.default)
    
    private var inserted: Department?
    
    init(completion: Closure<Void>? = nil) {
        container = NSPersistentContainer(name: "Company")
        container.loadPersistentStores { (store, error) in
            if error != nil {
                fatalError("Could not load persistent store")
            }
            completion?(())
        }
        NotificationCenter.default.addObserver(forName: Notification.Name.NSManagedObjectContextWillSave,
                                               object: nil,
                                               queue: nil) { [weak self] note in
                                                guard let context = note.object as? NSManagedObjectContext else { return }
                                                self?.inserted = context.insertedObjects.first { $0 is Department } as? Department
        }
        NotificationCenter.default.addObserver(forName: Notification.Name.NSManagedObjectContextDidSave,
                                               object: nil,
                                               queue: nil) { [weak self] note in
                                                guard let department = self?.inserted else { return }
                                                self?.sessionManager.execute(NetworkRequest.department.create(department: department))
                                                self?.inserted = nil
        }
    }

}
