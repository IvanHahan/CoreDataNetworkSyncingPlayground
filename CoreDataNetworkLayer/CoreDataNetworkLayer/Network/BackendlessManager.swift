//
//  BackendlessManager.swift
//  CoreDataNetworkLayer
//
//  Created by  Ivan Hahanov on 1/17/18.
//  Copyright © 2018  Ivan Hahanov. All rights reserved.
//

import Foundation

protocol BackendlessRequest {
    var table: String { get }
    var data: Parameters { get }
}

class BackendlessManager {
    
    let backendless: Backendless
    
    init(baseUrl: String) {
        self.backendless = Backendless.sharedInstance()
        backendless.hostURL = baseUrl
        backendless.initApp("50F43BB7-8B2B-0509-FF7B-3665F066E500", apiKey: "665536C6-6AD9-86EF-FF87-349DACBBCF00")
    }
    
    func save(_ request: BackendlessRequest, completion: ResultClosure<Void>) {
//        backendless.data.ofTable(request.table).save(request.json,
//                                                        response: <#T##((Any?) -> Void)!##((Any?) -> Void)!##(Any?) -> Void#>,
//                                                        error: <#T##((Fault?) -> Void)!##((Fault?) -> Void)!##(Fault?) -> Void#>)
        
    }
}


