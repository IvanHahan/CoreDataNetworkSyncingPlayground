//
//  CachedRequest+CoreDataProperties.swift
//  CoreDataNetworkLayer
//
//  Created by  Ivan Hahanov on 1/17/18.
//  Copyright © 2018  Ivan Hahanov. All rights reserved.edit
//
//

import Foundation
import CoreData


extension CachedRequest {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CachedRequest> {
        return NSFetchRequest<CachedRequest>(entityName: "CachedRequest")
    }

    @NSManaged public var pathOptional: String?
    @NSManaged public var body: Data?
    @NSManaged public var methodString: String?
    @NSManaged public var priorityRaw: Int16
}

extension CachedRequest: Request {
    typealias Model = Void

    var method: Method { return Method(rawValue: methodString!)! }
    var path: String { return pathOptional! }
}
