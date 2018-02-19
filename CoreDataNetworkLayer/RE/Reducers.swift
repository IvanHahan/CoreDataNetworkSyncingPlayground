//
//  Reducers.swift
//  CoreDataNetworkLayer
//
//  Created by Ivan Hahanov on 2/19/18.
//  Copyright © 2018  Ivan Hahanov. All rights reserved.
//

import Foundation
import ReSwift

func appReducer(action: Action, state: AppState?) -> AppState {
    return AppState(departmentsState: departmentReducer(action: action, state: state?.departmentsState))
}

func departmentReducer(action: Action, state: DepartmentsState?) -> DepartmentsState {
    var state = state ?? DepartmentsState(currentDepartment: nil, departments: [])
    switch action {
    case let action as AppAction.CreateDepartment:
        state.currentDepartment = action.department
    case let action as AppAction.AddDepartment:
        state.currentDepartment = nil
        state.departments.append(action.department)
    case let action as AppAction.GetDepartments:
        state.departments = action.departments
    case let action as AppAction.WaitAction:
        state.currentDepartment = nil
    default: ()
    }
    return state
}


