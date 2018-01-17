//
//  CoreData.swift
//  CoreDataNetworkLayer
//
//  Created by  Ivan Hahanov on 1/17/18.
//  Copyright © 2018  Ivan Hahanov. All rights reserved.
//

import Foundation
import CoreData

func loadPersistentStore(completion: @escaping Closure<NSPersistentContainer>) {
    let container = NSPersistentContainer(name: "Company")
    container.loadPersistentStores { (store, error) in
        if error != nil {
            fatalError("Could not load persistent store")
        }
        completion(container)
    }
}
