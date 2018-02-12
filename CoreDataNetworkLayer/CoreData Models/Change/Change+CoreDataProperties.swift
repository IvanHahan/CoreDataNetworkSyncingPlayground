//
//  Change+CoreDataProperties.swift
//  
//
//  Created by Ivan Hahanov on 2/9/18.
//
//

import Foundation
import CoreData


extension Change {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Change> {
        return NSFetchRequest<Change>(entityName: "Change")
    }

    @NSManaged public var changedObjectId: URL?
    @NSManaged public var request: CachedRequest?
    
}
