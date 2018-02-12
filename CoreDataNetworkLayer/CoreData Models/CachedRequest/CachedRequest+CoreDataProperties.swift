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
    @NSManaged public var name: String?
}

extension CachedRequest: Request {
    typealias Model = Data

    var method: Method { return Method(rawValue: methodString!)! }
    var path: String { return pathOptional! }
    
    func map(from data: Data) -> Data? {
        return data
    }
}
