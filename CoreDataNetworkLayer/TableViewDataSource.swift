//
//  TableViewDataSource.swift
//  CoreDataNetworkLayer
//
//  Created by  Ivan Hahanov on 1/16/18.
//  Copyright © 2018  Ivan Hahanov. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class TableViewDataSource<Model: NSManagedObject, Cell: UITableViewCell>: NSObject, UITableViewDataSource, UITableViewDelegate where Model: Managed {
    private let fetchController: NSFetchedResultsController<Model>
    private let cellConfiguration: Closure<(Cell, Model)>
    
    private weak var tableView: UITableView!
    
    var didSelectRow: Closure<Model>?
    
    init(tableView: UITableView, context: NSManagedObjectContext, cellConfiguration: @escaping Closure<(Cell, Model)>) {
        self.fetchController = NSFetchedResultsController<Model>(fetchRequest: Model.sortedFetchRequest,
                                                                 managedObjectContext: context,
                                                                 sectionNameKeyPath: nil,
                                                                 cacheName: nil)
        self.cellConfiguration = cellConfiguration
        self.tableView = tableView
        super.init()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(Cell.self)
    }
    
    func reload() {
        try? fetchController.performFetch()
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchController.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(resource: Cell.self, for: indexPath)
        cellConfiguration((cell, fetchController.object(at: indexPath)))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectRow?(fetchController.object(at: indexPath))
    }
}

