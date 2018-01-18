//
//  EmployeeSyncManager.swift
//  CoreDataNetworkLayer
//
//  Created by  Ivan Hahanov on 1/18/18.
//  Copyright © 2018  Ivan Hahanov. All rights reserved.
//

import Foundation
import CoreData

class EmployeeSyncManager {
    
    enum ChangeType {
        case insert([Employee]), update(Employee)
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
                                                let employees = context.insertedObjects.flatMap({ $0 as? Employee })
                                                if !employees.isEmpty {
                                                    self?.changing = .insert(employees)
                                                } else if let employee = context.updatedObjects.first(where: { $0 is Employee }) as? Employee {
                                                    self?.changing = .update(employee)
                                                }
        }
        NotificationCenter.default.addObserver(forName: Notification.Name.NSManagedObjectContextDidSave,
                                               object: nil,
                                               queue: nil) { [weak self] note in
                                                guard let changing = self?.changing else { return }
                                                switch changing {
                                                case .insert(let employees):
                                                    for employee in employees {
                                                        self?.requestCacher?.enqueue(NetworkRequest.employee.create(employee: employee))
                                                    }
                                                case .update(let employee):
                                                    break
//                                                    self?.requestCacher?.enqueue(NetworkRequest.employee.update(id: "", department: department))
                                                }
                                                self?.changing = nil
        }
    }
    
}
