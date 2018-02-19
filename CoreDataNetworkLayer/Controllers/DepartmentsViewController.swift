//
//  DepartmentsViewController.swift
//  CoreDataNetworkLayer
//
//  Created by  Ivan Hahanov on 1/16/18.
//  Copyright © 2018  Ivan Hahanov. All rights reserved.
//

import UIKit
import ReSwift

class DepartmentsViewController: UIViewController, StoreSubscriber {
    
    enum Segue: String {
        case employees
    }

    @IBOutlet weak var tableView: UITableView!
    var departments: [Department] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self)
        store.subscribe(self) {
            $0.select {
                $0.departmentsState
            }
        }
        store.dispatch(AppAction.fetchDepartments)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? EditDepartmentController {
        } else if let vc = segue.destination as? EmployeesViewController {
            vc.department = sender as? DepartmentModel
        }
    }
    
    @IBAction func unwindToDepartments(_ sender: UIStoryboardSegue) {
        guard let vc = sender.source as? EditDepartmentController else { return }
        vc.department.name = vc.nameField.text!
        let department = vc.department
        store.dispatch(AppAction.CreateDepartment(department: department))
    }
    
    func newState(state: DepartmentsState) {
        self.departments = state.departments
        tableView.reloadData()
        if let current = state.currentDepartment {
            store.dispatch(AppAction.createDepartment)
        }
    }
}

extension DepartmentsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return departments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(resource: UITableViewCell.self, for: indexPath)
        cell.textLabel?.text = departments[indexPath.row].name
        return cell
    }
}

extension DepartmentsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: Segue.employees.rawValue, sender: departments[indexPath.row])
    }
}
