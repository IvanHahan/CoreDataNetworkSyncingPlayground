//
//  Request.swift
//  CoreDataNetworkLayer
//
//  Created by  Ivan Hahanov on 1/15/18.
//  Copyright © 2018  Ivan Hahanov. All rights reserved.
//

import Foundation
import CoreData

typealias Parameters = [String: Any]

enum Method: String {
    case get = "GET", post = "POST", put = "PUT", delete = "DELETE"
}

protocol Model {
}


protocol Request {
    associatedtype Model
    
    var path: String { get }
    var method: Method { get }
    var body: Data? { get }
    
    func asURLRequest(baseUrl: String) -> URLRequest
    func map(from data: Data) -> Model?
}

extension Request {
    var method: Method { return .get }
    var body: Data? { return nil }
    
    func map(from data: Data) -> Model? {
        return nil
    }
    
    func asURLRequest(baseUrl: String) -> URLRequest {
        let fullPath = baseUrl.appending(path)
        var request = URLRequest(url: URL(string: fullPath)!)
        request.httpBody = body
        request.httpMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }

}

extension Request {
    @discardableResult
    func cache(into context: NSManagedObjectContext) -> CachedRequest {
        let cached: CachedRequest = context.new()
        cached.body = body
        cached.methodString = method.rawValue
        cached.pathOptional = path
        return cached
    }
}

protocol DecodableResultRequest: Request where Model: Decodable {
    
}

extension DecodableResultRequest {
    func map(from data: Data) -> Model? {
        let decoder = JSONDecoder()
        return try? decoder.decode(Model.self, from: data)
    }
}
