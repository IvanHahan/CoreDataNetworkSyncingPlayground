//
//  Request.swift
//  CoreDataNetworkLayer
//
//  Created by  Ivan Hahanov on 1/15/18.
//  Copyright © 2018  Ivan Hahanov. All rights reserved.
//

import Foundation

typealias Parameters = [String: Any]

enum Method {
    case get, post, put, delete
}

protocol Model {
}


protocol Request {
    associatedtype Model
    
    var path: String { get }
    var method: Method { get }
    var body: Parameters? { get }
    
    func asURLRequest(baseUrl: String) -> URLRequest
}

extension Request {
    var method: Method { return .get }
    var body: Parameters? { return nil }
    
    func asURLRequest(baseUrl: String) -> URLRequest {
        let fullPath = baseUrl.appending(path)
        let request = URLRequest(url: URL(string: fullPath)!)
        return request
    }
}

protocol DecodableResultRequest: Request where Model: Decodable {
    
}
