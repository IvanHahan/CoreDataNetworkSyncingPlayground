//
//  Change+CoreDataClass.swift
//  
//
//  Created by Ivan Hahanov on 2/9/18.
//
//

import Foundation
import CoreData

@objc(Change)
final public class Change: NSManagedObject {
    
}

extension Change: Managed {
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [
            NSSortDescriptor(key: #keyPath(request.priorityRaw), ascending: false)
        ]
    }
}
