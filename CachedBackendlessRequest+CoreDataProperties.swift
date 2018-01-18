//
//  CachedBackendlessRequest+CoreDataProperties.swift
//  
//
//  Created by  Ivan Hahanov on 1/18/18.
//
//

import Foundation
import CoreData


extension CachedBackendlessRequest {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CachedBackendlessRequest> {
        return NSFetchRequest<CachedBackendlessRequest>(entityName: "CachedBackendlessRequest")
    }

    @NSManaged public var parameters: NSObject?
    @NSManaged public var table: String?
    @NSManaged public var method: String?

}
