//
//  ShiftPointAnnotation.swift
//  ShiftLog
//
//  Created by Yi JIANG on 21/3/18.
//  Copyright © 2018 Siphty. All rights reserved.
//

import UIKit
import MapKit

class ShiftPointAnnotation: MKPointAnnotation {
    var shiftEventLocation: CLLocation?
    var name: String?
    var shiftEvent: ShiftLogItem?
    
    init(start shiftEvent: ShiftLogItem?) {
        super.init()
        guard let shiftEvent = shiftEvent else { return }
        self.shiftEvent = shiftEvent
        guard let longitude = shiftEvent.startLongitude, let latitude = shiftEvent.startLatitude else { return }
        let startLocation = CLLocation(latitude: CLLocationDegrees(Double(latitude) ?? 0.0),
                                       longitude: CLLocationDegrees(Double(longitude) ?? 0.0))
        title = "Shift Start Point"
        subtitle = shiftEvent.start
        coordinate = startLocation.coordinate
    }
    
    init(end shiftEvent: ShiftLogItem?) {
        super.init()
        guard let shiftEvent = shiftEvent else { return }
        self.shiftEvent = shiftEvent
        guard let longitude = shiftEvent.endLongitude, let latitude = shiftEvent.endLatitude else { return }
        let endLocation = CLLocation(latitude: CLLocationDegrees(Double(latitude) ?? 0.0),
                                     longitude: CLLocationDegrees(Double(longitude) ?? 0.0))
        title = "Shift End Point"
        subtitle = shiftEvent.end
        coordinate = endLocation.coordinate
    }
}
