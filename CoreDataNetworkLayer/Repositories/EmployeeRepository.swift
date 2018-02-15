//
//  EmployeeRepository.swift
//  CoreDataNetworkLayer
//
//  Created by Ivan Hahanov on 2/7/18.
//  Copyright © 2018  Ivan Hahanov. All rights reserved.
//

import Foundation
import CoreData
import Promise

class EmployeeRepository {
    
    private let sessionManager: SessionManager
    private unowned let actionCacher: ActionCacheManager
    let context: NSManagedObjectContext
    let container: NSPersistentContainer
    
    init(actionCacher: ActionCacheManager, sessionManager: SessionManager, context: NSManagedObjectContext, container: NSPersistentContainer) {
        self.actionCacher = actionCacher
        self.sessionManager = sessionManager
        self.context = context
        self.container = container
        configureObservers()
    }
    
    func create(_ model: Employee) -> Promise<Void> {
        return createLocally([model]).then(addCreateAction)
    }
    
    func create(_ models: [Employee]) -> Promise<Void> {
        return createLocally(models).then(addCreateAction)
    }
    
    private func addCreateAction(ids: [URL]) -> Promise<Void> {
        ids.forEach { localId in
            actionCacher.enqueue(table: Employee.self, actionType: .create, localId: localId, remoteId: nil)
        }
        return Promise(value: ())
    }
    
    private func createRemotely(_ model: Employee) -> Promise<String> {
        return sessionManager.execute(FirebaseRequest.employee.create(employee: model)).recover { _ in
            return self.createRemotely(model)
        }
    }
    
    private func createLocally(_ models: [Employee]) -> Promise<[URL]> {
        return Promise { fulfill, reject in
            self.context.perform {
                do {
                    let managedModels: [NSManagedObject] = models.map { model in
                        let managed: EmployeeModel = self.context.new()
                        managed.name = model.name
                        managed.position = model.position
                        managed.salary = model.salary
                        return managed
                    }
                    try self.context.save()
                    fulfill(managedModels.map { $0.objectID.uriRepresentation().absoluteURL })
                } catch {
                    reject(error)
                }
            }
        }
    }
    
    private func configureObservers() {
        NotificationCenter.default.addObserver(forName: Notification.Name(String(describing: Employee.self)),
                                               object: nil,
                                               queue: .main) { [weak self] note in
                                                guard let strongSelf = self, let payload = note.userInfo?[ActionKey.payload] as? ActionPayload else { return }
                                                switch payload {
                                                case .create(let localId):
                                                    if let managedId = strongSelf.container.managedObjectID(from: localId),
                                                        let model = try! strongSelf.context.existingObject(with: managedId) as? EmployeeModel {
                                                        let employee = Employee(name: model.name!, position: model.position!, salary: model.salary, id: nil)
                                                        strongSelf.createRemotely(employee).then { remoteId in
                                                            strongSelf.context.performChanges {
                                                                model.remoteId = remoteId
                                                                strongSelf.actionCacher.run()
                                                            }
                                                        }
                                                    }
                                                case .delete(let remoteId):
                                                    break
                                                case .update(let localId):
                                                    break
                                                }
        }

    }
}
