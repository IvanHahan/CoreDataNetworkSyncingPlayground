//
//  ViewController.swift
//  CoreDataNetworkLayer
//
//  Created by  Ivan Hahanov on 1/15/18.
//  Copyright © 2018  Ivan Hahanov. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var fetchController: NSFetchedResultsController<Employee>!
    var context: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self)
        
        context = (UIApplication.shared.delegate as! AppDelegate).dataController.container.viewContext
        
        let request = Employee.sortedFetchRequest
        fetchController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        try? fetchController.performFetch()
        tableView.reloadData()
    }
    
    @IBAction func unwind(_ sender: UIStoryboardSegue) {
        do {
            guard let vc = sender.source as? EditEmployeeController else { return }
            context.performChanges { [unowned self] in
                Employee.insert(name: vc.nameField.text!,
                                position: vc.positionField.text!,
                                salary: Double(vc.salaryField.text!)!,
                                into: self.context)
            }
            
            try fetchController.performFetch()
            tableView.reloadData()
        } catch {
            print(error)
        }
    }
    
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchController.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(resource: UITableViewCell.self, for: indexPath)
        cell.textLabel?.numberOfLines = 0
        let employee = fetchController.object(at: indexPath)
        cell.textLabel?.text = "name: \(employee.name!)\nposition: \(employee.position!)"
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    
}
