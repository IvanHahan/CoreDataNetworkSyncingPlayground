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
    var departmentSyncManager: SyncManager<DepartmentProcessor.Saver, DepartmentProcessor.Updater, DepartmentProcessor.Remover>!
    var employeeSyncManager: SyncManager<EmployeeProcessor.Saver, EmployeeProcessor.Updater, EmployeeProcessor.Remover>!
    var domainContainer: NSPersistentContainer!
    var cachingContainer: NSPersistentContainer!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        loadPersistentStore("Company") { container in
            self.domainContainer = container
        }
        loadPersistentStore("Caching") { container in
            let cacherContext = container.newBackgroundContext()
            let domainContext = self.domainContainer.newBackgroundContext()
            let requestCacheManager = RequestCacheManager(context: cacherContext)
            requestCacheManager.runCached()
            self.departmentSyncManager = SyncManager(name: "department",
                                                     context: domainContext,
                                                     saver: DepartmentProcessor.Saver(requestCacher: requestCacheManager),
                                                     updater: DepartmentProcessor.Updater(requestCacher: requestCacheManager),
                                                     remover: DepartmentProcessor.Remover(requestCacher: requestCacheManager))
            self.employeeSyncManager = SyncManager(name: "employee",
                                                   context: domainContext,
                                                   saver: EmployeeProcessor.Saver(requestCacher: requestCacheManager),
                                                   updater: EmployeeProcessor.Updater(requestCacher: requestCacheManager),
                                                   remover: EmployeeProcessor.Remover(requestCacher: requestCacheManager))
            self.departmentSyncManager.addDependency(self.employeeSyncManager)
            self.cachingContainer = container
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

