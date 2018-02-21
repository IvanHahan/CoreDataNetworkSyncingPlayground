//
//  DepartmentsViewController.swift
//  CoreDataNetworkLayer
//
//  Created by  Ivan Hahanov on 1/16/18.
//  Copyright © 2018  Ivan Hahanov. All rights reserved.
//

import UIKit
import ReSwift

class DepartmentsViewController: UIViewController {
    
    enum Segue: String {
        case employees
    }

    @IBOutlet weak var tableView: UITableView!
    var departments: [Department] = []
    var store: Store<DepartmentsState>!
    var departmentsRepository: DepartmentRepository!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self)
        
        departmentsRepository = (UIApplication.shared.delegate as! AppDelegate).departmentRepository
        store = Store(reducer: departmentReducer, state: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        store.subscribe(self)
        store.dispatch(DepartmentAction.GetDepartments(repository: departmentsRepository))
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        store.unsubscribe(self)
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
        store.dispatch(DepartmentAction.CreateDepartment(department: department, repository: departmentsRepository))
    }
}

extension DepartmentsViewController: StoreSubscriber {
    func newState(state: DepartmentsState) {
        switch state {
        case .finished(let departments):
            self.departments = departments
            tableView.reloadData()
        case .added(let department):
            departments.append(department)
            tableView.insertRows(at: [IndexPath.init(row: departments.count - 1, section: 0)], with: .automatic)
        case .failure(let error):
            print(error)
        case .loading:
            print("loading")
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
