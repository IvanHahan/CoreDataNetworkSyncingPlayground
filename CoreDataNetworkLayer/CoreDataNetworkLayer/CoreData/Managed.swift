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
    
    func remap(to context: NSManagedObjectContext) -> Self {
        guard managedObjectContext !== context else { return self }
        return context.object(with: objectID) as! Self
    }
}

extension Sequence where Iterator.Element: NSManagedObject & Managed {
    func remap(to context: NSManagedObjectContext) -> [Self.Element] {
        return map { $0.remap(to: context) }
    }
}

extension NSManagedObject {
    func toJsonData() -> Data {
        let keys = Array(entity.attributesByName.keys)
        let dict = dictionaryWithValues(forKeys: keys)
        return try! JSONSerialization.data(withJSONObject: dict, options: [])
    }
}

extension NSManagedObjectContext {
    func new<T: NSManagedObject>() -> T {
        return NSEntityDescription.insertNewObject(forEntityName: T.entity().name!, into: self) as! T
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

extension NSPersistentContainer {
    func managedObjectID(from uri: URL) -> NSManagedObjectID? {
        return persistentStoreCoordinator.managedObjectID(forURIRepresentation: uri)
    }
}
