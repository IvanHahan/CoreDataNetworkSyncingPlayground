//
//  BackendlessManager.swift
//  CoreDataNetworkLayer
//
//  Created by  Ivan Hahanov on 1/17/18.
//  Copyright © 2018  Ivan Hahanov. All rights reserved.
//

import Foundation

enum BackendlessRequest<Model: Decodable> {
    case save(object: Model, completion: ResultClosure<Void>)
    case find(query: DataQueryBuilder, completion: ResultClosure<Model>)
    case remove(object: Model, completion: ResultClosure<Void>)
}

class BackendlessManager {
    
    let backendless: Backendless
    
    init() {
        self.backendless = Backendless.sharedInstance()
        backendless.hostURL = "https://api.backendless.com"
        backendless.initApp("50F43BB7-8B2B-0509-FF7B-3665F066E500", apiKey: "665536C6-6AD9-86EF-FF87-349DACBBCF00")
    }
    
    func execute<Model>(_ request: BackendlessRequest<Model>, for table: String) {
        switch request {
        case .find(let query, let completion):
            backendless.data.ofTable(table).find(query, response: { result in
                do {
                    let decoder = JSONDecoder()
                    let model = try decoder.decode(Model.self, from: JSONSerialization.data(withJSONObject: result!, options: []))
                    completion(.success(model))
                } catch {
                    completion(.failure(error))
                }
            }, error: { (error) in
                completion(.failure(NSError(domain: error!.detail,
                                            code: Int(error!.faultCode)!,
                                            userInfo: [NSLocalizedDescriptionKey: error!.message])))
                })
        case .save(let object, let completion):
            backendless.data.ofTable(table).save(object,
                                                 response: { result in
                                                    completion(.success(()))
            }, error: { error in
                completion(.failure(NSError(domain: error!.detail,
                                            code: Int(error!.faultCode)!,
                                            userInfo: [NSLocalizedDescriptionKey: error!.message])))
                })
        case .remove(let object, let completion):
            backendless.data.ofTable(table).remove(object, response: { (id) in
                
            }, error: { (error) in
                completion(.failure(NSError(domain: error!.detail,
                                            code: Int(error!.faultCode)!,
                                            userInfo: [NSLocalizedDescriptionKey: error!.message])))
                })
        }
    }
}


