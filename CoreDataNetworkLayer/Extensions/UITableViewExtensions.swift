//
//  UITableViewExtensions.swift
//  Twignature
//
//  Created by Ivan Hahanov on 9/5/17.
//  Copyright © 2017 Zfort. All rights reserved.
//

import UIKit.UITableView

extension UITableView {
    
    func register<T: UITableViewCell>(_ resource: T.Type) {
        register(resource, forCellReuseIdentifier: T.identifier)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(resource: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as! T
    }
}

