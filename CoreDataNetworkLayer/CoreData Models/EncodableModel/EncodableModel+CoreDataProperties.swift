//
//  EncodableModel+CoreDataProperties.swift
//  
//
//  Created by Ivan Hahanov on 2/9/18.
//
//

import Foundation
import CoreData


extension EncodableModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EncodableModel> {
        return NSFetchRequest<EncodableModel>(entityName: "EncodableModel")
    }
}
