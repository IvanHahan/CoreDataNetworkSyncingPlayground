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
    private var changing: ChangeType?
    var requestCacher: RequestCacheManager?

    init(context: NSManagedObjectContext) {
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
                                                    self?.requestCacher?.enqueue(NetworkRequest.department.create(department: department))
                                                case .update(let department):
                                                    self?.requestCacher?.enqueue(NetworkRequest.department.update(id: "", department: department))
                                                }
                                                self?.changing = nil
        }
    }

}