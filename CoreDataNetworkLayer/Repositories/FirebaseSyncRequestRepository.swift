//
//  FirebaseSyncRequestRepository.swift
//  CoreDataNetworkLayer
//
//  Created by Ivan Hahanov on 2/9/18.
//  Copyright © 2018  Ivan Hahanov. All rights reserved.
//

import Foundation
import CoreData
import Promise

class FirebaseSyncRequestRepository {
    
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func create<R: FirebaseModelSyncRequest>(_ model: R) {
        context.performChanges {
            model.cache(into: self.context)
        }
    }
    
    func getLast<R: FirebaseModelSyncRequest>() -> Promise<R> {
        return Promise { fulfill, reject in
            self.context.perform {
                if let request = FirebaseSyncRequest.findOrFetchFirst(in: self.context) as? R {
                    fulfill(request)
                } else {
                    reject(RepositoryError.notFound)
                }
            }
        }
    }
    
    func delete<R: FirebaseModelSyncRequest>(_ model: R) {
        context.performChanges {
            if let managed = model as? FirebaseSyncRequest {
                self.context.delete(managed)
            }
        }
    }
}
