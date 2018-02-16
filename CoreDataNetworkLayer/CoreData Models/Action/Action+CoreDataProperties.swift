//
//  Action+CoreDataProperties.swift
//  
//
//  Created by Ivan Hahanov on 2/14/18.
//
//

import Foundation
import CoreData

extension Action {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Action> {
        return NSFetchRequest<Action>(entityName: "Action")
    }

    @NSManaged public var modelName: String?
    @NSManaged public var localId: URL?
    @NSManaged public var remoteId: String?
    @NSManaged public var type: String?
    @NSManaged public var timestamp: TimeInterval
}

// MARK: Generated accessors for dependencies
extension Action {

}
