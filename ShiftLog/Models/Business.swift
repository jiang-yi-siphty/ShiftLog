//
//  Business.swift
//
//  RootClass.swift
//  Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport
//
//  Created by Yi JIANG on 18/3/18.
//  Copyright © 2018 Siphty. All rights reserved.

import Foundation

struct Business : Codable {
    
    let logo : String?
    let name : String?
    
    
    enum CodingKeys: String, CodingKey {
        case logo = "logo"
        case name = "name"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        logo = try values.decodeIfPresent(String.self, forKey: .logo)
        name = try values.decodeIfPresent(String.self, forKey: .name)
    }
    
    
}
