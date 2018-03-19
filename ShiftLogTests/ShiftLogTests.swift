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
