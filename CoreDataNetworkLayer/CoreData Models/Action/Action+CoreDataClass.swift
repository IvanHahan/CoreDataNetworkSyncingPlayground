//
//  Action+CoreDataClass.swift
//  
//
//  Created by Ivan Hahanov on 2/14/18.
//
//

import Foundation
import CoreData

@objc(ModelChange)
final public class ModelChange: NSManagedObject, Managed {

    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [
            NSSortDescriptor(key: #keyPath(timestamp), ascending: true)
        ]
    }
}
