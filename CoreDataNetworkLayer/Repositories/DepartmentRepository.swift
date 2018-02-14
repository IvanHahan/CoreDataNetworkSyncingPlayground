//
//  Repository.swift
//  CoreDataNetworkLayer
//
//  Created by Ivan Hahanov on 2/6/18.
//  Copyright © 2018  Ivan Hahanov. All rights reserved.
//

import Foundation
import CoreData
import Promise

class DepartmentRepository {
    
    private let actionCacher: ActionCacheManager
    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext
    private let sessionManager: SessionManager
    
    init(actionCacher: ActionCacheManager, sessionManager: SessionManager, context: NSManagedObjectContext, container: NSPersistentContainer) {
        self.actionCacher = actionCacher
        self.sessionManager = sessionManager
        self.context = context
        self.container = container
        configureObservers()
    }
    
    func create(_ model: Department) -> Promise<Void> {
        return createLocally(model).then(addCreateAction)
    }
    
    func get() -> Promise<[Department]> {
        return Promise(queue: DispatchQueue.global(qos: .background)) { fulfill, reject in
            do {
                let fetched = try self.context.fetch(DepartmentModel.fetchRequest(configured: {$0.includesPropertyValues = true}))
                let mapped = fetched.map { (managed) -> Department in
                    var model = Department()
                    model.name = managed.name
                    model.id = managed.remoteId
                    return model
                }
                fulfill(mapped)
            } catch {
                reject(error)
            }
        }
    }
    
    private func addCreateAction(modelId: URL) {
        actionCacher.enqueue(table: Employee.self, actionType: .create, localId: modelId, remoteId: nil)
    }
    
    private func createRemotely(_ model: Department) -> Promise<String> {
        return sessionManager.execute(FirebaseRequest.department.create(department: model)).recover { _ in
            return self.createRemotely(model)
        }
    }
    
    private func createLocally(_ model: Department) -> Promise<URL> {
        return Promise(queue: DispatchQueue.global(qos: .background)) { fulfill, reject in
            self.context.perform {
                do {
                    let managed: DepartmentModel = self.context.new()
                    managed.name = model.name
                    model.employees.flatMap {
                        managed.employees = Set($0.map { emp in
                            let empManaged: EmployeeModel = self.context.new()
                            empManaged.name = emp.name
                            empManaged.remoteId = emp.id
                            empManaged.salary = emp.salary
                            return empManaged
                        })
                    }
                    try self.context.save()
                    fulfill(managed.objectID.uriRepresentation().absoluteURL)
                } catch {
                    print(error.localizedDescription)
                    reject(error)
                }
            }
        }
    }
    
    private func configureObservers() {
        NotificationCenter.default.addObserver(forName: Notification.Name(String(describing: Department.self)),
                                               object: nil,
                                               queue: .main) { [weak self] note in
                                                guard let strongSelf = self, let payload = note.userInfo?[ActionKey.payload] as? ActionPayload else { return }
                                                switch payload {
                                                case .create(let localId):
                                                    if let managedId = strongSelf.container.managedObjectID(from: localId),
                                                        let model = try! strongSelf.context.existingObject(with: managedId) as? DepartmentModel {
                                                        let employees = model.employees?.map { Employee(name: $0.name!, position: $0.position!, salary: $0.salary, id: $0.remoteId!) } ?? []
                                                        let department = Department(name: model.name!, employees: employees)
                                                        strongSelf.createRemotely(department).then { remoteId in
                                                            strongSelf.context.performChanges {
                                                                model.remoteId = remoteId
                                                                strongSelf.actionCacher.triggerNext()
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
