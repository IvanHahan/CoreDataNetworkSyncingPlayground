//
//  Executable.swift
//  CoreDataNetworkLayer
//
//  Created by  Ivan Hahanov on 1/22/18.
//  Copyright © 2018  Ivan Hahanov. All rights reserved.
//

import Foundation

enum State {
    case pending, executing, finished
}

protocol Executable: class {
    var state: State { get set }
    var didChangeState: Closure<State>? { get set }
}
