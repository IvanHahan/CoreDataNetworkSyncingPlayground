//
//  DepartmentsViewController.swift
//  CoreDataNetworkLayer
//
//  Created by  Ivan Hahanov on 1/16/18.
//  Copyright © 2018  Ivan Hahanov. All rights reserved.
//

import UIKit
import CoreData

class DepartmentsViewController: UIViewController {
    
    enum Segue: String {
        case employees
    }

    @IBOutlet weak var tableView: UITableView!
    
    var context: NSManagedObjectContext!
    var tableViewDataSource: TableViewDataSource<Department, UITableViewCell>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        context = (UIApplication.shared.delegate as! AppDelegate).dataController.container.viewContext
        tableViewDataSource = TableViewDataSource<Department, UITableViewCell>(tableView: tableView,
                                                                               context: context,
                                                                               cellConfiguration: { (cell, department) in
                                                                                cell.textLabel?.text = department.name
        })
        tableViewDataSource.didSelectRow = { [unowned self] department in
            self.performSegue(withIdentifier: Segue.employees.rawValue, sender: department)
        }
        tableViewDataSource.reload()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? EditDepartmentController {
            vc.context = context
        } else if let vc = segue.destination as? EmployeesViewController {
            vc.department = sender as? Department
            vc.context = context
        }
    }
    
    @IBAction func unwindToDepartments(_ sender: UIStoryboardSegue) {
        do {
            guard let vc = sender.source as? EditDepartmentController else { return }
            vc.department.name = vc.nameField.text
            try context.save()
            tableViewDataSource.reload()
        } catch {
            print(error)
        }
    }
}
