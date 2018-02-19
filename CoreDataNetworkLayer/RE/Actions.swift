//
//  Actions.swift
//  CoreDataNetworkLayer
//
//  Created by Ivan Hahanov on 2/16/18.
//  Copyright © 2018  Ivan Hahanov. All rights reserved.
//

import Foundation
import ReSwift

enum AppAction {
    struct AddDepartment: Action { var department: Department }
    struct GetDepartments: Action { var departments: [Department] }
    struct CreateDepartment: Action { var department: Department }
    struct WaitAction: Action { }
    
    static func createDepartment(state: AppState, store: Store<AppState>) -> WaitAction {
        let store = store as! MainStore
        let department = state.departmentsState.currentDepartment!
        
        store.departmentsRepository.create(department).then {
            store.dispatch(AppAction.AddDepartment(department: department))
        }
        
        return WaitAction()
    }
    
    static func fetchDepartments(state: AppState, store: Store<AppState>) -> GetDepartments {
        let store = store as! MainStore
        store.departmentsRepository.get().then {
            store.dispatch(GetDepartments(departments:$0))
        }
        return GetDepartments(departments: [])
    }
}
