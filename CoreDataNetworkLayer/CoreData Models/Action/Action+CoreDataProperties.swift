//
//  Action+CoreDataProperties.swift
//  
//
//  Created by Ivan Hahanov on 2/14/18.
//
//

import Foundation
import CoreData

enum ActionType: String {
    case create, delete, update
}

extension Action {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Action> {
        return NSFetchRequest<Action>(entityName: "Action")
    }

    @NSManaged public var modelName: String?
    @NSManaged public var localId: URL?
    @NSManaged public var remoteId: String?
    @NSManaged public var type: String?
    @NSManaged public var dependencies: Set<Action>?

}

// MARK: Generated accessors for dependencies
extension Action {

    @objc(addDependenciesObject:)
    @NSManaged public func addToDependencies(_ value: Action)

    @objc(removeDependenciesObject:)
    @NSManaged public func removeFromDependencies(_ value: Action)

    @objc(addDependencies:)
    @NSManaged public func addToDependencies(_ values: NSSet)

    @objc(removeDependencies:)
    @NSManaged public func removeFromDependencies(_ values: NSSet)

}
