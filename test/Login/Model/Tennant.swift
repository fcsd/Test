//
//  Tennat.swift
//  test
//
//  Created by admin on 1/20/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation

class Tennant {
    
    let name: String
    let types: [TennatType]
    
    init?(json: [String: Any]) {
        guard let name = json["name"] as? String else { return nil }
        guard let types = json["security_types"] as? [String] else { return nil }
        
        self.name = name
        self.types = types.compactMap{ TennatType(rawValue: $0) }
    }
}

public enum TennatType: String {
    case password = "password"
    case guest = "guest"
}
