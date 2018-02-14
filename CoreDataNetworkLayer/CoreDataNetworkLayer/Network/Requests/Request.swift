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

enum Priority: Int16 {
    case low, medium, high
}

protocol Request {
    associatedtype Model
    
    var path: String { get }
    var method: Method { get }
    var body: Data? { get }
    var priority: Priority { get }
    static var name: String { get }
    
    func asURLRequest(baseUrl: String) -> URLRequest
    func map(from data: Data) -> Model?
    
    @discardableResult
    func cache(into context: NSManagedObjectContext) -> NSManagedObject
}

extension Request {
    var method: Method { return .get }
    var body: Data? { return nil }
    var priority: Priority { return .medium }
    static var name: String {
        return String(describing: Self.self)
    }
    
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
    func cache(into context: NSManagedObjectContext) -> NSManagedObject {
        let cached: CachedRequest = context.new()
        cached.body = body
        cached.methodString = method.rawValue
        cached.pathOptional = path
        cached.priorityRaw = priority.rawValue
        cached.name = Self.name
        return cached
    }
}

protocol BackendlessModelSyncRequest: Request where Model == String {
}

extension BackendlessModelSyncRequest {
    func map(from data: Data) -> String? {
        let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        return json??["objectId"] as? String
    }
}

protocol FirebaseModelSyncRequest: Request where Model == String {
}

extension FirebaseModelSyncRequest {
    func map(from data: Data) -> String? {
        let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        return json??["name"] as? String
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
