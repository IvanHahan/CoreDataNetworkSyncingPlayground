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
    static func findOrFetchFirst(in context: NSManagedObjectContext) -> Self?
}

extension Managed where Self: NSManagedObject {
    
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return []
    }
    
    static var sortedFetchRequest: NSFetchRequest<Self> {
        let request = NSFetchRequest<Self>(entityName: Self.entity().name ?? Self.identifier)
        request.sortDescriptors = defaultSortDescriptors
        return request
    }
    
    static func fetchRequest(configured: Closure<NSFetchRequest<Self>>) -> NSFetchRequest<Self> {
        let request = self.sortedFetchRequest
        configured(request)
        return request
    }
    
    static func findOrFetchFirst(in context: NSManagedObjectContext) -> Self? {
        if let last = context.registeredObjects.first(where: {$0 is Self}) as? Self {
            return last
        } else {
            return try! context.fetch(Self.fetchRequest {
                $0.fetchLimit = 1
                $0.includesPropertyValues = true
            }).first
        }
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
