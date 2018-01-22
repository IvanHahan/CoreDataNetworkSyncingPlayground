//
//  ChangeProcessor.swift
//  CoreDataNetworkLayer
//
//  Created by  Ivan Hahanov on 1/19/18.
//  Copyright © 2018  Ivan Hahanov. All rights reserved.
//

import Foundation

protocol ChangeProcessor {
    associatedtype Model
    
    var comlpetion: Closure<Void>? { get set }
    func process(_ models: [Model], completion: ResultClosure<Model>?)
}
