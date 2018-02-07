//
//  DepartmentsViewController.swift
//  CoreDataNetworkLayer
//
//  Created by  Ivan Hahanov on 1/16/18.
//  Copyright © 2018  Ivan Hahanov. All rights reserved.
//

import UIKit

class DepartmentsViewController: UIViewController {
    
    enum Segue: String {
        case employees
    }

    @IBOutlet weak var tableView: UITableView!
    var departments: [Department] = []
    var repository: DepartmentRepository!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self)
        let context = (UIApplication.shared.delegate as! AppDelegate).domainContainer.newBackgroundContext()
        let requestManager = (UIApplication.shared.delegate as! AppDelegate).requestManager!
        repository = DepartmentRepository(requestCacher: requestManager, context: context)
        repository.get().then {
            self.departments = $0
            self.tableView.reloadData()
        }
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
        repository.create(vc.department).then(repository.get).then {
            self.departments = $0
            self.tableView.reloadData()
            }.catch { error in
                print(error.localizedDescription)
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
