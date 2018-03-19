//
//  Shift.swift
//  ShiftLog
//
//  RootClass.swift
//  Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport
//
//  Created by Yi JIANG on 18/3/18.
//  Copyright © 2018 Siphty. All rights reserved.
//

import Foundation

struct ShiftEvent : Codable {
    
    let latitude : String?
    let longitude : String?
    let time : String?
    
    
    enum CodingKeys: String, CodingKey {
        case latitude = "latitude"
        case longitude = "longitude"
        case time = "time"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        latitude = try values.decodeIfPresent(String.self, forKey: .latitude)
        longitude = try values.decodeIfPresent(String.self, forKey: .longitude)
        time = try values.decodeIfPresent(String.self, forKey: .time)
    }
    
    
}
import Foundation
