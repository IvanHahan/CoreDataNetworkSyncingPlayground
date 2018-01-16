//
//  Managed.swift
//  CoreDataNetworkLayer
//
//  Created by  Ivan Hahanov on 1/15/18.
//  Copyright © 2018  Ivan Hahanov. All rights reserved.
//

import Foundation
import CoreData

protocol Managed: NSFetchRequestResult, Identifiable {
    static var defaultSortDescriptors: [NSSortDescriptor] { get }
    static var sortedFetchRequest: NSFetchRequest<Self> { get }
}

extension Managed where Self: NSManagedObject {
    
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return []
    }
    
    static var sortedFetchRequest: NSFetchRequest<Self> {
        let request = NSFetchRequest<Self>(entityName: Self.identifier)
        request.sortDescriptors = defaultSortDescriptors
        return request
    }
}

extension NSManagedObjectContext {
    func new<T: NSManagedObject>() -> T {
        return NSEntityDescription.insertNewObject(forEntityName: T.identifier, into: self) as! T
    }
    
    @discardableResult
    func saveOrRollback() -> Bool {
        do {
            try save()
            return true
        } catch {
            rollback()
            return false
        }
    }
    
    func performChanges(block: @escaping Closure<Void>) {
        perform {
            block(())
            self.saveOrRollback()
        }
    }
}
