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
    private var apiService: ApiService? = nil
    enum status: Int {
        case start = 0
        case end
    }
    
    init(_ apiService: ApiService) {
        self.apiService = apiService
    }
    
    public func startShiftEvent(){
        //TODO: If network has issue, fetch data from DB
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
                    //TODO: Store current status
                    case .fail(let error):
                        //TODO: Restore current status
                        print(error.errorDescription ?? "Faild to load Scenic Location data")
                        self.isAlertShowing.value = true
                    }
                }, onError: { error in
                    //TODO: Restore current status
                    print(error.localizedDescription)
                }, onCompleted: nil, onDisposed: nil)
                .disposed(by: disposeBag)
        } catch {
            //TODO: Handel exception
        }
    }
    
    public func endShiftEvent() {
        //TODO: If network has issue, fetch data from DB
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
                    //TODO: Store current status
                    case .fail(let error):
                        print(error.errorDescription ?? "Faild to load Scenic Location data")
                        self.isAlertShowing.value = true
                    }
                }, onError: { error in
                    //TODO: Restore current status
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
