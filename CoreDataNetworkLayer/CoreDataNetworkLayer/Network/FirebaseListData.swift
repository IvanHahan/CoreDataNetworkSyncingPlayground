//
//  FirebaseListData.swift
//  CoreDataNetworkLayer
//
//  Created by Ivan Hahanov on 2/1/18.
//  Copyright © 2018  Ivan Hahanov. All rights reserved.
//

import Foundation

struct FirebaseListData<Element: Decodable>: Decodable {
    let data: [String: Element]
}
