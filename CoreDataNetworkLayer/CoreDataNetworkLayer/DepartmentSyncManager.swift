//
//  DataController.swift
//  CoreDataNetworkLayer
//
//  Created by  Ivan Hahanov on 1/15/18.
//  Copyright © 2018  Ivan Hahanov. All rights reserved.
//

import Foundation
import CoreData

class DepartmentSyncManager {
    
    enum ChangeType {
        case insert(Department), update(Department)
    }
    
    let context: NSManagedObjectContext
    private let sessionManager: SessionManager = SessionManager(baseUrl: "https://com.example.blat/", config: URLSessionConfiguration.default)
    
    private var changing: ChangeType?

    init(context: NSManagedObjectContext, completion: Closure<Void>? = nil) {
        self.context = context
        NotificationCenter.default.addObserver(forName: Notification.Name.NSManagedObjectContextWillSave,
                                               object: nil,
                                               queue: nil) { [weak self] note in
                                                guard let context = note.object as? NSManagedObjectContext else { return }
                                                if let department = context.insertedObjects.first(where: { $0 is Department }) as? Department {
                                                    self?.changing = .insert(department)
                                                } else if let department = context.updatedObjects.first(where: { $0 is Department }) as? Department {
                                                    self?.changing = .update(department)
                                                }
        }
        NotificationCenter.default.addObserver(forName: Notification.Name.NSManagedObjectContextDidSave,
                                               object: nil,
                                               queue: nil) { [weak self] note in
                                                guard let changing = self?.changing else { return }
                                                switch changing {
                                                case .insert(let department):
                                                    self?.sessionManager.execute(NetworkRequest.department.create(department: department))
                                                case .update(let department):
                                                    self?.sessionManager.execute(NetworkRequest.department.update(department: department))
                                                }
                                                self?.changing = nil
        }
    }

}
