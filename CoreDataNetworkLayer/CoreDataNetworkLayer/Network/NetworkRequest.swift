//
//  NetworkRequest.swift
//  CoreDataNetworkLayer
//
//  Created by  Ivan Hahanov on 1/16/18.
//  Copyright © 2018  Ivan Hahanov. All rights reserved.
//

import Foundation

enum NetworkRequest {
    enum employee {
        struct create: DecodableResultRequest {
            
            typealias Model = Employee
            
            let path: String = ""
            let method: Method = .post
            let body: Parameters? = [:]
        }
        
        struct update: DecodableResultRequest {
            
            typealias Model = Employee
            
            let path: String = ""
            let method: Method = .put
            let body: Parameters? = [:]
        }
        
        struct get: DecodableResultRequest {
            
            typealias Model = Employee
            
            let path: String = ""
        }
        
        struct delete: DecodableResultRequest {
            
            typealias Model = Employee
            
            let path: String = ""
            let method: Method = .delete
        }
    }
    
    enum department {
        struct create: DecodableResultRequest {
            
            typealias Model = Department
            
            let path: String = ""
            let method: Method = .post
            let body: Parameters? = [:]
            
            init(department: Department) {
                
            }
        }
        
        struct update: DecodableResultRequest {
            
            typealias Model = Department
            
            let path: String = ""
            let method: Method = .post
            let body: Parameters? = [:]
            
            init(department: Department) {
                
            }
        }
    }
}
