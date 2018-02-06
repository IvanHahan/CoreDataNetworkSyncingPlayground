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
    var departmentSyncManager: SyncManager<DepartmentProcessor>!
    var employeeSyncManager: SyncManager<EmployeeProcessor>!
    var domainContainer: NSPersistentContainer!
    var cachingContainer: NSPersistentContainer!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        loadPersistentStore("Company") { container in
            self.domainContainer = container
        }
        
        loadPersistentStore("Caching") { container in
            let cachingContext = container.newBackgroundContext()
            let domainContext = self.domainContainer.newBackgroundContext()
            let sessionManager = SessionManager(baseUrl: Environment.firebase.baseUrl, config: URLSessionConfiguration.default)
            let requestCacheManager = RequestCacheManager(sessionManager: sessionManager, context: cachingContext, domainContainer: self.domainContainer)
            requestCacheManager.run()
            self.departmentSyncManager = SyncManager(name: "department",
                                                     context: domainContext,
                                                     changeProcessor: DepartmentProcessor(requestCacher: requestCacheManager))
            self.employeeSyncManager = SyncManager(name: "employee",
                                                   context: domainContext,
                                                   changeProcessor: EmployeeProcessor(requestCacher: requestCacheManager))
            self.departmentSyncManager.addDependency(self.employeeSyncManager)
            self.cachingContainer = container
        }
        return true
    }
}

