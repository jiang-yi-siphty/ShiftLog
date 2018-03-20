//
//  ShiftEventViewModel.swift
//  ShiftLog
//
//  Created by Yi Jiang on 20/3/18.
//  Copyright © 2018 Siphty. All rights reserved.
//

import Foundation
import RxSwift
import CoreLocation
import Firebase

class ShiftEventViewModel {
    
    let disposeBag = DisposeBag()
    var shiftEvent = Variable<ShiftEvent?>(nil)
    var isFetchingData = Variable<Bool>(false)
    var isAlertShowing = Variable<Bool>(false)
    var isInShift = Variable<Bool>(false)
    private var apiService: ApiService? = nil
    enum status: Int {
        case start = 0
        case end
    }
    
    init(_ apiService: ApiService) {
        self.apiService = apiService
        restoreShiftEvent { inShift in
            self.isInShift.value = inShift ?? false
        }
    }
    
    public func startShiftEvent(){
        restoreShiftEvent { inShift in
            self.isInShift.value = inShift ?? false
        }
        do {
            let body = try JSONEncoder().encode(createShiftEvent())
            guard let apiService = self.apiService else { return }
            apiService.postRestfulApi(ApiConfig.startShift, body: body)
                .subscribe(onNext: { status in
                    self.isFetchingData.value = false
                    switch status {
                    case .success(let data):
                        guard let data = data else { return }
                        print("POST Successful " + data.description)
                        self.storeShiftEvent(inShift: true)
                    case .fail(let error):
                        self.restoreShiftEvent { inShift in
                            self.isInShift.value = inShift ?? false
                        }
                        print(error.errorDescription ?? "Faild to load Scenic Location data")
                        self.isAlertShowing.value = true
                    }
                }, onError: { error in
                    self.restoreShiftEvent { inShift in
                        self.isInShift.value = inShift ?? false
                    }
                    print(error.localizedDescription)
                }, onCompleted: nil, onDisposed: nil)
                .disposed(by: disposeBag)
        } catch {
            //TODO: Handel exception
        }
    }
    
    public func endShiftEvent() {
        restoreShiftEvent { inShift in
            self.isInShift.value = inShift ?? true
        }
        do {
            let body = try JSONEncoder().encode(createShiftEvent())
            guard let apiService = self.apiService else { return }
            apiService.postRestfulApi(ApiConfig.endShift, body: body)
                .subscribe(onNext: { status in
                    self.isFetchingData.value = false
                    switch status {
                    case .success(let data):
                        guard let data = data else { return }
                        print("POST Successful " + data.description)
                        self.storeShiftEvent(inShift: false)
                    case .fail(let error):
                        self.restoreShiftEvent { inShift in
                            self.isInShift.value = inShift ?? true
                        }
                        print(error.errorDescription ?? "Faild to load Scenic Location data")
                        self.isAlertShowing.value = true
                    }
                }, onError: { error in
                    self.restoreShiftEvent { inShift in
                        self.isInShift.value = inShift ?? true
                    }
                    print(error.localizedDescription)
                }, onCompleted: nil, onDisposed: nil)
                .disposed(by: disposeBag)
        } catch {
            //TODO: Handel exception
        }
        
    }
    
    private func createShiftEvent() -> ShiftEvent {
        var shiftEvent = ShiftEvent()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        shiftEvent.time = dateFormatter.string(from: Date())
        let currentLocation = getCurrentLocation()
        shiftEvent.longitude = "\(currentLocation?.coordinate.longitude ?? 0.0)"
        shiftEvent.latitude = "\(currentLocation?.coordinate.longitude ?? 0.0)"
        return shiftEvent
    }
    
    private func getCurrentLocation() -> CLLocation? {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let locationManager = appDelegate.locationManager
        
        var currentLocation: CLLocation? = nil
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                if #available(iOS 11.0, *) {
                    locationManager.requestAlwaysAuthorization()
                } else {
                    locationManager.requestWhenInUseAuthorization()
                }
            case .authorizedAlways, .authorizedWhenInUse:
                currentLocation = locationManager.location
            }
        } else {
            print("Location services are not enabled")
        }
        return currentLocation
    }
}

//Firebase DB / Offline DB
extension ShiftEventViewModel {
    func storeShiftEvent(inShift: Bool) {
        let shiftEventRef = Database.database().reference(withPath: "ShiftStatus")
        isInShift.value = inShift
        shiftEventRef.child("InShift").setValue(inShift)
    }
    
    func restoreShiftEvent(_ handler:@escaping ((_ inShift: Bool?) -> Void) ){
        let shiftEventRef = Database.database().reference(withPath: "ShiftStatus")
        shiftEventRef.child("InShift").observeSingleEvent(of: .value, with: { (snapshot) in
            handler(snapshot.value as? Bool)
        })
    }
}
