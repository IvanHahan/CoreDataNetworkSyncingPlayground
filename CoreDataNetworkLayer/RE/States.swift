//
//  States.swift
//  CoreDataNetworkLayer
//
//  Created by Ivan Hahanov on 2/19/18.
//  Copyright © 2018  Ivan Hahanov. All rights reserved.
//

import Foundation
import ReSwift

struct AppState: StateType {
    let departmentsState: DepartmentsState
}

enum DepartmentsState: StateType {
    case loading, finished([Department]), added(Department), failure(Error)
}
