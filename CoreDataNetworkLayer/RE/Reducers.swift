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
    let state = state ?? .finished([])
    switch action {
    case let action as DepartmentAction.AddDepartment:
        return .added(action.department)
    case let action as DepartmentAction.SetDepartments:
        return .finished(action.departments)
    case _ as Loading:
        return .loading
    case let action as Failure:
        return .failure(action.error)
    default:
        return state
    }
}


