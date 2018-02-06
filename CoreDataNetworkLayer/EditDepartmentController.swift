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
    var employees = Set<EmployeeModel>()
    var context: NSManagedObjectContext!
    var department: DepartmentModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let dep: DepartmentModel = context.new()
        department = dep
    }

    @IBAction func unwind(sender: UIStoryboardSegue) {
        guard let vc = sender.source as? EditEmployeeController else { return }
        EmployeeModel.insert(name: vc.nameField.text!,
                        position: vc.positionField.text!,
                        salary: Double(vc.salaryField.text!)!,
                        department: self.department,
                        into: self.context)
    }

}
