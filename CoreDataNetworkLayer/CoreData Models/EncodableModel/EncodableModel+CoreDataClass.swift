//
//  EncodableModel+CoreDataClass.swift
//  
//
//  Created by Ivan Hahanov on 2/9/18.
//
//

import Foundation
import CoreData

@objc(EncodableModel)
public class EncodableModel: NSManagedObject, Encodable {
    public func encode(to encoder: Encoder) throws {
        
    }
}
