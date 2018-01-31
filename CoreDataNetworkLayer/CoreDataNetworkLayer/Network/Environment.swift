//
//  Environment.swift
//  CoreDataNetworkLayer
//
//  Created by Ivan Hahanov on 1/31/18.
//  Copyright © 2018  Ivan Hahanov. All rights reserved.
//

import Foundation

enum Environment {
    case backendless
    case firebase
    
    var baseUrl: String {
        switch self {
        case .backendless:
            return "https://api.backendless.com/50F43BB7-8B2B-0509-FF7B-3665F066E500/7D915167-68FB-B6C8-FF9D-2EE480B58F00/"
        case .firebase:
            return "https://companytest-cb1dc.firebaseio.com/"
        }
    }
}
