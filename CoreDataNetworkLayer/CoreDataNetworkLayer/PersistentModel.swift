//
//  PersistentModel.swift
//  CoreDataNetworkLayer
//
//  Created by  Ivan Hahanov on 1/16/18.
//  Copyright © 2018  Ivan Hahanov. All rights reserved.
//

import Foundation


typealias PersistentModel = Managed & Codable

protocol SyncedModel: class {
    var remoteId: String? { get set }
}
