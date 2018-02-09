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
public class Change: NSManagedObject {
    enum ChangeType: String {
        case .create
    }
}
