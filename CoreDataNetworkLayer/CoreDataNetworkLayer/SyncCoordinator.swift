//
//  SyncCoordinator.swift
//  CoreDataNetworkLayer
//
//  Created by Ivan Hahanov on 2/9/18.
//  Copyright © 2018  Ivan Hahanov. All rights reserved.
//

import Foundation


class SyncCoordinator {
    private let requestCacher: RequestCacheManager
    
    init(requestCacher: RequestCacheManager) {
        self.requestCacher = requestCacher
    }
    
    func sync<R: FirebaseModelSyncRequest>(_ request: R) {
        
    }
}
