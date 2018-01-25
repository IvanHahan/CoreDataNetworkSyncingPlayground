//
//  SyncManager.swift
//  CoreDataNetworkLayer
//
//  Created by  Ivan Hahanov on 1/19/18.
//  Copyright © 2018  Ivan Hahanov. All rights reserved.
//

import Foundation
import CoreData

class SyncManager<Saver: ChangeProcessor, Updater: ChangeProcessor, Remover: ChangeProcessor>: Executable
where Saver.Model: SyncedModel, Updater.Model: SyncedModel, Remover.Model: SyncedModel {
    
    enum Change {
        case create([Saver.Model]), update([Updater.Model]), delete([Remover.Model])
    }
    
    var didChangeState: Closure<State>?
    
    private var dependencies: [Executable] = []
    private var changes: [Change] = []
    private let context: NSManagedObjectContext
    private var remoteSaver: Saver
    private var remoteUpdater: Updater
    private var remoteRemover: Remover
    
    let name: String
    
    var state: State = .finished {
        didSet {
            didChangeState?(state)
        }
    }
    
    init(name: String,
         context: NSManagedObjectContext,
         saver: Saver,
         updater: Updater,
         remover: Remover) {
        self.name = name
        self.context = context
        self.remoteSaver = saver
        self.remoteRemover = remover
        self.remoteUpdater = updater
        let completion: Closure<Void> = { [weak self] _ in
            self?.state = .finished
        }
        remoteRemover.comlpetion = completion
        remoteSaver.comlpetion = completion
        remoteUpdater.comlpetion = completion
        NotificationCenter.default.addObserver(forName: Notification.Name.NSManagedObjectContextWillSave,
                                               object: nil,
                                               queue: nil) { [weak self] note in
                                                guard let context = note.object as? NSManagedObjectContext, context !== self?.context else { return }
                                                guard let strongSelf = self else { return }
                                                let inserted = context.insertedObjects.flatMap{ $0 as? Saver.Model }
                                                    .flatMap { $0.remoteId == nil ? $0 : nil }.remap(to: strongSelf.context)
                                                let updated = context.updatedObjects.flatMap { $0 as? Updater.Model }
                                                    .flatMap { $0.remoteId != nil ? $0 : nil }.remap(to: strongSelf.context)
                                                let deleted = context.deletedObjects.flatMap { $0 as? Remover.Model }
                                                    .flatMap { $0.remoteId != nil ? $0 : nil }.remap(to: strongSelf.context)
                                                if !inserted.isEmpty {
                                                    self?.state = .pending
                                                    self?.changes.append(.create(inserted))
                                                }
                                                if !updated.isEmpty {
                                                    self?.state = .pending
                                                    self?.changes.append(.update(updated))
                                                }
                                                if !deleted.isEmpty {
                                                    self?.state = .pending
                                                    self?.changes.append(.delete(deleted))
                                                }
        }
        NotificationCenter.default.addObserver(forName: Notification.Name.NSManagedObjectContextDidSave,
                                               object: nil,
                                               queue: nil) { [weak self] note in
                                                guard let context = note.object as? NSManagedObjectContext, context !== self?.context else { return }
                                                guard let strongSelf = self else { return }
                                                self?.perform {
                                                    self?.changes.forEach {
                                                        self?.state = .executing
                                                        switch $0 {
                                                        case .create(let models):
                                                            self?.remoteSaver.process(models, context: strongSelf.context)
                                                        case .update(let models):
                                                            self?.remoteUpdater.process(models, context: strongSelf.context)
                                                        case .delete(let models):
                                                            self?.remoteRemover.process(models, context: strongSelf.context)
                                                        }
                                                    }
                                                    self?.changes = []
                                                }
        }
    }
    
    func addDependency(_ dependency: Executable) {
        dependencies.append(dependency)
    }
    
    func removeDependency(_ dependency: Executable) {
        guard let index = dependencies.index(where: { dependency === $0 }) else { return }
        dependencies.remove(at: index)
    }
    
    private var dispatchGroup: DispatchGroup!
    private func perform(block: @escaping ()->()) {
        dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        dependencies.forEach { dependency in
            if dependency.state != .finished {
                dispatchGroup.enter()
            } else {
                return
            }
            dependency.didChangeState = { [weak self] state in
                if state == .finished {
                    self?.dispatchGroup.leave()
                }
            }
        }
        dispatchGroup.leave()
        dispatchGroup.notify(queue: .main) {
            block()
        }
    }
    
}
