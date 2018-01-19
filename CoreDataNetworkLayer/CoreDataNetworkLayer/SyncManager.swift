//
//  SyncManager.swift
//  CoreDataNetworkLayer
//
//  Created by  Ivan Hahanov on 1/19/18.
//  Copyright © 2018  Ivan Hahanov. All rights reserved.
//

import Foundation
import CoreData

class SyncManager<P: ChangeProcessor where P.> {
    
    enum Change {
        case create([T]), update([T]), delete([String])
    }
    
    private var changes: [Change] = []
    private let context: NSManagedObjectContext
    private let remoteSaver: ChangeProcessor<T>
    private let remoteUpdater: Closure<(String, T)>
    private let remoteRemover: Closure<[String]>
    
    private(set) var isExecutiong: Bool = false
    
    init(context: NSManagedObjectContext,
         saver: @escaping Closure<[T]>,
         updater: @escaping Closure<(String, T)>,
         remover: @escaping Closure<[String]>) {
        self.context = context
        self.remoteSaver = saver
        self.remoteRemover = remover
        self.remoteUpdater = updater
        
        NotificationCenter.default.addObserver(forName: Notification.Name.NSManagedObjectContextWillSave,
                                               object: nil,
                                               queue: nil) { [weak self] note in
                                                guard let context = note.object as? NSManagedObjectContext else { return }
                                                let inserted = context.insertedObjects.flatMap{ $0 as? T }
                                                let updated = context.updatedObjects.flatMap { $0 as? T }.first
                                                let deleted = context.deletedObjects.flatMap { $0 as? T }.map{ $0.remoteId }
                                                if !inserted.isEmpty {
                                                    self?.changes.append(.create(inserted))
                                                }
                                                if let updated = updated {
                                                    self?.changes.append(.update(id: updated.remoteId, model: updated))
                                                }
                                                if !deleted.isEmpty {
                                                    self?.changes.append(.delete(deleted))
                                                }
        }
        NotificationCenter.default.addObserver(forName: Notification.Name.NSManagedObjectContextDidSave,
                                               object: nil,
                                               queue: nil) { [weak self] note in
                                                self?.isExecutiong = true
                                                self?.changes.forEach {
                                                    switch $0 {
                                                    case .create(let models):
                                                        self?.remoteSaver(models)
                                                    case .update(let id, let model):
                                                        self?.remoteUpdater((id, model))
                                                    case .delete(let models):
                                                        self?.remoteRemover(models)
                                                    }
                                                }
                                                self?.changes = []
        }
    }
}
