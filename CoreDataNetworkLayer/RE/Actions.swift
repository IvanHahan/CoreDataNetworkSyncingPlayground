//
//  Actions.swift
//  CoreDataNetworkLayer
//
//  Created by Ivan Hahanov on 2/16/18.
//  Copyright © 2018  Ivan Hahanov. All rights reserved.
//

import Foundation
import ReSwift

struct Loading: Action {}
struct Failure: Action { let error: Error }

enum DepartmentAction {
    struct AddDepartment: Action { var department: Department }
    struct SetDepartments: Action { var departments: [Department] }
    
    static func CreateDepartment(department: Department, repository: DepartmentRepository) -> (DepartmentsState, Store<DepartmentsState>) -> Action? {
        return { state, store in
            repository.create(department).then {
                    store.dispatch(AddDepartment(department: department))
                }.catch {
                    store.dispatch(Failure(error: $0))
            }
            return Loading()
        }
    }
    
    static func GetDepartments(repository: DepartmentRepository) -> (DepartmentsState, Store<DepartmentsState>) -> Action? {
        return { state, store in
            repository.get().then {
                    store.dispatch(SetDepartments(departments: $0))
                }.catch {
                    store.dispatch(Failure(error: $0))
            }
            return Loading()
        }
    }
}

