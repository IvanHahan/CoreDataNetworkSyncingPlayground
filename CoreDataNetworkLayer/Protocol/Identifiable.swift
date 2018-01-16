//
//  Identifiable.swift
//  Nexter
//
//  Created by  Ivan Hahanov on 12/28/17.
//  Copyright © 2017 zfort. All rights reserved.
//

import UIKit
import CoreData

protocol Identifiable {
    static var identifier: String { get }
}

extension Identifiable {
    static var identifier: String {
        return String(describing: Self.self)
    }
}

extension UIView: Identifiable {}
extension NSManagedObject: Identifiable {}
