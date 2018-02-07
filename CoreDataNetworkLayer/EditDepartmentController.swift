//
//  EditDepartmentController.swift
//  CoreDataNetworkLayer
//
//  Created by  Ivan Hahanov on 1/16/18.
//  Copyright © 2018  Ivan Hahanov. All rights reserved.
//

import UIKit
import CoreData

class EditDepartmentController: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    var department: Department = Department()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func unwind(sender: UIStoryboardSegue) {
        guard let vc = sender.source as? EditEmployeeController else { return }
        let employee = Employee(name: vc.nameField.text!, position: vc.positionField.text!, salary: Double(vc.salaryField.text!)!, id: nil)
        department.employees?.append(employee)
    }

}
