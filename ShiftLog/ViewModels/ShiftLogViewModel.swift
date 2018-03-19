//
//  ShiftLogViewModel.swift
//  ShiftLog
//
//  Created by Yi JIANG on 19/3/18.
//  Copyright © 2018 Siphty. All rights reserved.
//

import Foundation
import RxSwift
//import RxCocoa
import CoreLocation

class ShiftLogViewModel {
    
    let disposeBag = DisposeBag()
    var apiClient: ApiClient? = nil
    var locationManager: CLLocationManager? = nil
    var shiftLogs = Variable<[ShiftLogItem]?>(nil)
    var isFetchingData = Variable<Bool>(false)
    var isAlertShowing = Variable<Bool>(false)
    private var apiService: ApiService? = nil
    
    init(_ apiService: ApiService) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        locationManager = appDelegate.locationManager
        fetchShiftLogs(apiService)
        self.apiService = apiService
    }
    
    func updateScenicLocation() {
        guard let apiService = self.apiService else { return }
        fetchShiftLogs(apiService)
    }
    
    fileprivate func fetchShiftLogs(_ apiService: ApiService) {
        self.isFetchingData.value = true
        apiService.fetchRestfulApi(ApiConfig.shiftLogs)
            .subscribe(onNext: { status in
                self.isFetchingData.value = false
                switch status {
                case .success(let data):
                    guard let data = data else { return }
                    do {
                        self.shiftLogs.value =  try JSONDecoder().decode([ShiftLogItem].self, from: data)
                        self.isAlertShowing.value = false
                    } catch {
                        self.shiftLogs.value = nil
                        self.isAlertShowing.value = true
                    }
                case .fail(let error):
                    print(error.errorDescription ?? "Faild to load Scenic Location data")
                    self.isAlertShowing.value = true
                }
            }, onError: { error in
                print(error.localizedDescription)
                self.shiftLogs.value = nil
            }, onCompleted: nil, onDisposed: nil)
            .disposed(by: disposeBag)
    }
}
