//
//  Action+CoreDataClass.swift
//  
//
//  Created by Ivan Hahanov on 2/14/18.
//
//

import Foundation
import CoreData

@objc(Action)
final public class Action: NSManagedObject, Managed {

    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [
            NSSortDescriptor(key: #keyPath(index), ascending: false)
        ]
    }
    
    static var descendingSorting: [NSSortDescriptor] {
        return self.defaultSortDescriptors
    }
    
    static var ascendingSorting: [NSSortDescriptor] {
        return [
            NSSortDescriptor(key: #keyPath(index), ascending: true)
        ]
    }
}
