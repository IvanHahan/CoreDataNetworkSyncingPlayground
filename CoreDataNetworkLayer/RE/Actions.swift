//
//  Actions.swift
//  CoreDataNetworkLayer
//
//  Created by Ivan Hahanov on 2/16/18.
//  Copyright © 2018  Ivan Hahanov. All rights reserved.
//

import Foundation
import ReSwift

struct waitAction: Action { }

enum DepartmentAction {
    struct addDepartment: Action { var department: Department }
    struct getDepartments: Action { var departments: [Department] }
    struct selectDepartment: Action { var department: Department }
    
    static func createDepartment(state: DepartmentsState, store: Store<DepartmentsState>) -> waitAction {
        let store = store as! DepartmentStore
        let department = state.currentDepartment!
        
        store.departmentsRepository.create(department).then {
            store.dispatch(addDepartment(department: department))
        }
        
        return waitAction()
    }
    
    static func fetchDepartments(state: DepartmentsState, store: Store<DepartmentsState>) -> waitAction {
        let store = store as! DepartmentStore
        store.departmentsRepository.get().then {
            store.dispatch(getDepartments(departments: $0))
        }
        return waitAction()
    }
}

