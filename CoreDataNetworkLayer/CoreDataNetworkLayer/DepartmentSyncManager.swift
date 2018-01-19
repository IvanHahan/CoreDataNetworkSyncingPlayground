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
    
    private let context: NSManagedObjectContext
    private var changing: ChangeType?
//    var child: Emplos
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
                                                    self?.requestCacher?.enqueue(NetworkRequest.department.create(department: department)) { result in
                                                        
                                                    }
                                                case .update(let department):
                                                    self?.requestCacher?.enqueue(NetworkRequest.department.update(id: "", department: department))
                                                }
                                                self?.changing = nil
        }
    }

    private func createDepartmentRemotely(department: Department) {
//        self.requestCacher?.enqueue(NetworkRequest.department.create(department: department)) { [weak self] result in
//            switch result {
//            case .success(let model):
//                self?.context.performChanges {
//                    department.id = model.id
//                    self?.establishRelationsWithEmployeesRemotely(deparment: department)
//                }
//            case .failure(let error):
//                break
//            }
//        }
    }
    
    private func establishRelationsWithEmployeesRemotely(deparment: Department) {
//        self.requestCacher
    }
}
