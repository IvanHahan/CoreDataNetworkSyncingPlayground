//
//  AppDelegate.swift
//  CoreDataNetworkLayer
//
//  Created by  Ivan Hahanov on 1/15/18.
//  Copyright © 2018  Ivan Hahanov. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var domainContainer: NSPersistentContainer!
    var cachingContainer: NSPersistentContainer!
    var actionManager: ActionCacheManager!
    var departmentRepository: DepartmentRepository!
    var employeeRepository: EmployeeRepository!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        loadPersistentStore("Company") { container in
            self.domainContainer = container
        }
        
        loadPersistentStore("Caching") { container in
            let cachingContext = container.newBackgroundContext()
            let domainContext = self.domainContainer.newBackgroundContext()
            let sessionManager = SessionManager(baseUrl: Environment.firebase.baseUrl, config: URLSessionConfiguration.default)
            let actionCacheManager = ActionCacheManager(context: cachingContext)
            actionCacheManager.triggerNext()
            let depRep = DepartmentRepository(actionCacher: actionCacheManager, sessionManager: sessionManager, context: domainContext, container: self.domainContainer)
            let empRep = EmployeeRepository(actionCacher: actionCacheManager, sessionManager: sessionManager, context: domainContext, container: self.domainContainer)
            self.departmentRepository = depRep
            self.employeeRepository = empRep
            self.actionManager = actionCacheManager
            self.cachingContainer = container
        }
        return true
    }
}

