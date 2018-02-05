//
//  OperationExtension.swift
//  CoreDataNetworkLayer
//
//  Created by Ivan Hahanov on 2/5/18.
//  Copyright © 2018  Ivan Hahanov. All rights reserved.
//

import Foundation

extension Operation {
    func dependent(to op: Operation) -> Operation {
        self.addDependency(op)
        return self
    }
}
