//
//  SessionManager.swift
//  CoreDataNetworkLayer
//
//  Created by  Ivan Hahanov on 1/15/18.
//  Copyright © 2018  Ivan Hahanov. All rights reserved.
//

import Foundation
import Promise

protocol Cancellable {
    func cancel()
}

extension URLSessionDataTask: Cancellable {}

enum NetworkError: LocalizedError {
    case couldNotParseJSON
}

class SessionManager {

    enum State {
        case pending, executing, cancelled, finished
    }
    
    var didChangeState: Closure<State>?
    
    private let session: URLSession
    private let baseUrl: String
    private var executingTasks = Set<URLSessionDataTask>()
    private let syncGroup = DispatchGroup()
    private(set) var state = State.pending {
        didSet {
            didChangeState?(state)
        }
    }
    
    init(baseUrl: String, config: URLSessionConfiguration) {
        session = URLSession(configuration: config)
        self.baseUrl = baseUrl
    }
    
    @discardableResult
    func execute<R: Request>(_ request: R) -> Promise<R.Model> {
        state = .executing
        var task: URLSessionDataTask?
        return Promise<R.Model> { [weak self] handle, reject in
            guard let strongSelf = self else { return }
            task = strongSelf.session.dataTask(with: request.asURLRequest(baseUrl: strongSelf.baseUrl)) { [weak self] (data, response, error) in
                strongSelf.executingTasks.remove(task!)
                debugPrint(response)
                if let error = error {
                    reject(error)
                } else if let data = data {
                    if let model = request.map(from: data) {
                        handle(model)
                    } else {
                        reject(NetworkError.couldNotParseJSON)
                    }
                }
                self?.state = .finished
            }
            task?.resume()
            strongSelf.executingTasks.insert(task!)
        }
    }
    
    func cancel() {
        executingTasks.forEach { $0.cancel() }
        executingTasks.removeAll()
        state = .cancelled
    }
    
    func synchronize<R: DecodableResultRequest>(_ requests: [R], completion: Closure<Void>? = nil) {
        requests.forEach {
            syncGroup.enter()
            execute($0).always { [weak self] in
                self?.syncGroup.leave()
            }
        }
        syncGroup.notify(queue: .main) {
            completion?(())
        }
    }
}
