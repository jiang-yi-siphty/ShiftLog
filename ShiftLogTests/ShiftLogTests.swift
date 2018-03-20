//
//  ShiftLogTests.swift
//  ShiftLogTests
//
//  Created by Yi JIANG on 19/3/18.
//  Copyright © 2018 Siphty. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa
import CoreLocation

class ShiftLogTests: XCTestCase {
    fileprivate let disposeBag = DisposeBag()
    var viewModel: ShiftLogViewModel?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    func testShiftLogsApi() {
        let apiClient = ApiClient()
        apiClient.fetchRestfulApi(ApiConfig.shiftLogs)
            .subscribe(onNext: { status in
                var shiftLogs: [ShiftLogItem]?
                switch status {
                case .success(let data):
                    guard let data = data else {
                        XCTAssertTrue(false)
                        return
                    }
                    do {
                        shiftLogs = try JSONDecoder().decode([ShiftLogItem].self, from: data)
                    } catch {
                        shiftLogs = []
                    }
                    XCTAssertTrue(shiftLogs!.count > 0)
                //MARK: We can test more key:value to verify the decode logic is right.
                case .fail(let error):
                    print(error.errorDescription ?? "Faild to load ScenicLocation data")
                    XCTAssertFalse(true)
                }
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: disposeBag)
    }
    
    
    func testBusinessApi() {
        let apiClient = ApiClient()
        apiClient.fetchRestfulApi(ApiConfig.bussiness)
            .subscribe(onNext: { status in
                var business: Business?
                switch status {
                case .success(let data):
                    guard let data = data else {
                        XCTAssertTrue(false)
                        return
                    }
                    do {
                        business = try JSONDecoder().decode(Business.self, from: data)
                        print("\(business.debugDescription)")
                    } catch {
                        business = nil
                        XCTAssertTrue(false)
                    }
                    guard let businessName = business?.name else {
                        XCTAssertTrue(false)
                        return
                    }
                    XCTAssertTrue(business?.name == "Deputy")
                    XCTAssertTrue(business?.logo == "https://www.myob.com/au/addons/media/logos/deputy_logo_1.png")
                //MARK: We can test more key:value to verify the decode logic is right.
                case .fail(let error):
                    print(error.errorDescription ?? "Faild to load ScenicLocation data")
                    XCTAssertFalse(true)
                }
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: disposeBag)
    }
    
    func testStartShiftApi() {
        do {
            let apiClient = ApiClient()
            let body = try JSONEncoder().encode(createShiftEvent())
            apiClient.postRestfulApi(ApiConfig.startShift, body: body)
                .subscribe(onNext: { status in
                    switch status {
                    case .success(let data):
                        guard let data = data else {
                            XCTAssertTrue(false)
                            return
                        }
                        print(data)
                    //MARK: We can test more key:value to verify the decode logic is right.
                    case .fail(let error):
                        print(error.errorDescription ?? "Faild to load ScenicLocation data")
                        XCTAssertFalse(true)
                    }
                }, onError: nil, onCompleted: nil, onDisposed: nil)
                .disposed(by: disposeBag)
        } catch {
            print("JSON encoder throw exception")
        }
    }
    
    func testEndShiftApi() {
        do {
            let apiClient = ApiClient()
            let body = try JSONEncoder().encode(createShiftEvent())
            apiClient.postRestfulApi(ApiConfig.endShift, body: body)
                .subscribe(onNext: { status in
                    switch status {
                    case .success(let data):
                        guard let data = data else {
                            XCTAssertTrue(false)
                            return
                        }
                        print(data)
                    //MARK: We can test more key:value to verify the decode logic is right.
                    case .fail(let error):
                        print(error.errorDescription ?? "Faild to load ScenicLocation data")
                        XCTAssertFalse(true)
                    }
                }, onError: nil, onCompleted: nil, onDisposed: nil)
                .disposed(by: disposeBag)
        } catch {
            print("JSON encoder throw exception")
        }
    }
            
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}

extension ShiftLogTests {
    
    func createShiftEvent() -> ShiftEvent {
        var shiftEvent = ShiftEvent()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        shiftEvent.time = dateFormatter.string(from: Date())
        let currentLocation = getCurrentLocation()
        shiftEvent.longitude = "\(currentLocation?.coordinate.longitude ?? 0.0)"
        shiftEvent.latitude = "\(currentLocation?.coordinate.longitude ?? 0.0)"
        return shiftEvent
    }
    
    func getCurrentLocation() -> CLLocation? {
        let locationManager = CLLocationManager()
        
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
