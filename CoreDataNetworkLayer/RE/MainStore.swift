//
//  MainStore.swift
//  CoreDataNetworkLayer
//
//  Created by Ivan Hahanov on 2/19/18.
//  Copyright © 2018  Ivan Hahanov. All rights reserved.
//

import Foundation
import ReSwift

class MainStore: Store<AppState> {
    
    let departmentsRepository: DepartmentRepository
    
    init(reducer: @escaping Reducer<AppState>, departmentRepository: DepartmentRepository) {
        self.departmentsRepository = departmentRepository
        super.init(reducer: reducer, state: nil)
    }
    
    required init(reducer: @escaping (Action, State?) -> State, state: State?, middleware: [(@escaping DispatchFunction, @escaping () -> State?) -> (@escaping DispatchFunction) -> DispatchFunction]) {
        fatalError()
    }
}
