//
//  SyncManager.swift
//  CoreDataNetworkLayer
//
//  Created by  Ivan Hahanov on 1/19/18.
//  Copyright © 2018  Ivan Hahanov. All rights reserved.
//

import Foundation


protocol SyncManager {
    associatedtype Model
    
    func create(model: Model)
    func delete(id: String)
    func update(model: Model)
    func get(model: [Model])
}
