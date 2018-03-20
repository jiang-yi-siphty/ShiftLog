//
//  ShiftMapViewController.swift
//  ShiftLog
//
//  Created by Yi JIANG on 21/3/18.
//  Copyright © 2018 Siphty. All rights reserved.
//

import UIKit
import MapKit

class ShiftMapViewController: UIViewController {
    
    @IBOutlet var shiftMapView: MKMapView!
    var shiftLogItem: ShiftLogItem?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shiftMapView.showsUserLocation = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadShiftLogItem()
    }

    private func loadShiftLogItem() {
        guard let item = shiftLogItem else { return }
        let annotations = [ ShiftPointAnnotation.init(start: item),
                            ShiftPointAnnotation.init(end: item)]
        self.shiftMapView.addAnnotations(annotations)
        self.shiftMapView.showAnnotations(annotations, animated: true)
    }
}
