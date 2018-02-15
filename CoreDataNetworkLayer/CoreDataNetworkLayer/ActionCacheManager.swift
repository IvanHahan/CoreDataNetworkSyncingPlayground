//
//  ActionCacheManager.swift
//  CoreDataNetworkLayer
//
//  Created by Ivan Hahanov on 2/14/18.
//  Copyright © 2018  Ivan Hahanov. All rights reserved.
//

import Foundation
import CoreData

enum ActionType: String {
    case create, delete, update
}

enum ActionKey {
    static let payload = "payload"
}

enum ActionPayload {
    case create(localId: URL)
    case delete(remoteId: String)
    case update(localId: URL)
}

class ActionCacheManager {
    
    private let context: NSManagedObjectContext
    private var currentAction: Action?
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func run() {
        context.perform {
            self.triggerNext()
        }
    }
    
    func enqueue<T>(table: T.Type, actionType: ActionType, localId: URL?, remoteId: String?) {
        context.perform {
            let action: Action = self.context.new()
            action.index = (try! self.context.fetch(Action.fetchRequest(configured: { request in
                request.fetchBatchSize = 1
            })).first?.index ?? 0) + 1
            action.localId = localId
            action.remoteId = remoteId
            action.type = actionType.rawValue
            action.modelName = String(describing: table)
            self.context.saveOrRollback()
            if self.currentAction == nil {
                self.triggerNext()
            }
        }
    }
    
    private func triggerNext() {
        if let action = self.currentAction {
            self.context.delete(action)
            self.context.saveOrRollback()
            self.currentAction = nil
        }
        
        guard let action = try! self.context.fetch(Action.fetchRequest(configured: { request in
            request.fetchBatchSize = 1
            request.includesPropertyValues = true
            request.sortDescriptors = Action.ascendingSorting
        })).first else { return }
        let actionType = ActionType(rawValue: action.type!)!
        var payload: ActionPayload
        switch actionType {
        case .create:
            payload = .create(localId: action.localId!)
        case .delete:
            payload = .delete(remoteId: action.remoteId!)
        case .update:
            payload = .update(localId: action.localId!)
        }
        self.currentAction = action
        NotificationCenter.default.post(name: Notification.Name(action.modelName!),
                                        object: nil,
                                        userInfo: [ActionKey.payload: payload])
    }
}
