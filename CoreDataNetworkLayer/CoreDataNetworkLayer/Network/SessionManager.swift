//
//  SessionManager.swift
//  CoreDataNetworkLayer
//
//  Created by  Ivan Hahanov on 1/15/18.
//  Copyright © 2018  Ivan Hahanov. All rights reserved.
//

import Foundation

protocol Cancellable {
    func cancel()
}

extension URLSessionDataTask: Cancellable {}

enum NetworkError: LocalizedError {
    case couldNotParseJSON
}

class SessionManager {
    
    private let session: URLSession
    private let baseUrl: String
    private var executingTasks = Set<URLSessionDataTask>()
    private let syncGroup = DispatchGroup()
    
    init(baseUrl: String, config: URLSessionConfiguration) {
        session = URLSession(configuration: config)
        self.baseUrl = baseUrl
    }
    
    @discardableResult
    func execute<R: Request>(_ request: R, completion: ResultClosure<R.Model>? = nil) -> Cancellable {
        var task: URLSessionDataTask!
        task = session.dataTask(with: request.asURLRequest(baseUrl: baseUrl)) { [weak self] (data, response, error) in
            self?.executingTasks.remove(task)
            debugPrint(response)
            if let error = error {
                completion?(.failure(error))
            } else if let data = data {
                if let model = request.map(from: data) {
                    completion?(.success(model))
                } else {
                    completion?(.failure(NetworkError.couldNotParseJSON))
                }
            }
        }
        task.resume()
        executingTasks.insert(task)
        return task
    }
    
    func synchronize<R: DecodableResultRequest>(_ requests: [R], completion: Closure<Void>? = nil) {
        requests.forEach {
            syncGroup.enter()
            execute($0) { [weak self] _ in
                self?.syncGroup.leave()
            }
        }
        syncGroup.notify(queue: .main) {
            completion?(())
        }
    }
}
