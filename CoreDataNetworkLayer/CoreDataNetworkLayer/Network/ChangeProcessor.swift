//
//  ChangeProcessor.swift
//  CoreDataNetworkLayer
//
//  Created by  Ivan Hahanov on 1/19/18.
//  Copyright © 2018  Ivan Hahanov. All rights reserved.
//

import Foundation
import CoreData

protocol ChangeProcessor {
    associatedtype Model: NSManagedObject, Managed
    
    var comlpetion: Closure<Void>? { get set }
    func save(_ models: [Model])
    func update(_ models: [Model])
    func delete(_ ids: [String])
}
