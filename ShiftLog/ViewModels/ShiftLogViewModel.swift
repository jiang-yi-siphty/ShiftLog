//
//  ShiftLogViewModel.swift
//  ShiftLog
//
//  Created by Yi JIANG on 19/3/18.
//  Copyright © 2018 Siphty. All rights reserved.
//

import Foundation
import RxSwift
import Firebase

class ShiftLogViewModel {
    
    let disposeBag = DisposeBag()
    var shiftLogs = Variable<[ShiftLogItem]>([])
    var isFetchingData = Variable<Bool>(false)
    var isAlertShowing = Variable<Bool>(false)
    private var apiService: ApiService? = nil
    
    init(_ apiService: ApiService) {
        fetchShiftLogs(apiService)
        self.apiService = apiService
    }
    
    func updateShiftLogs() {
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
                    self.storeUserShiftLogs(data)
                    do {
                        self.shiftLogs.value = try JSONDecoder().decode([ShiftLogItem].self, from: data)
                        self.isAlertShowing.value = false
                    } catch {
                        self.shiftLogs.value = []
                        self.isAlertShowing.value = true
                    }
                case .fail(let error):
                    self.restoreUserShiftLogs({ data in
                        guard let data = data else { return }
                        do {
                        self.shiftLogs.value = try JSONDecoder().decode([ShiftLogItem].self, from: data)
                        } catch {
                            self.shiftLogs.value = []
                            self.isAlertShowing.value = true
                        }
                    })
                    print(error.errorDescription ?? "Faild to load Scenic Location data")
                    self.isAlertShowing.value = true
                }
            }, onError: { error in
                self.restoreUserShiftLogs({ data in
                    guard let data = data else { return }
                    do {
                        self.shiftLogs.value = try JSONDecoder().decode([ShiftLogItem].self, from: data)
                    } catch {
                        self.shiftLogs.value = []
                        self.isAlertShowing.value = true
                    }
                })
                print(error.localizedDescription)
            }, onCompleted: nil, onDisposed: nil)
            .disposed(by: disposeBag)
    }
}

//Firebase DB / Offline DB
extension ShiftLogViewModel {
    func storeUserShiftLogs(_ data: Data) {
        let shiftLogsRef = Database.database().reference(withPath: ApiConfig.firstNameYiSHA1)
        let dataString = String(data: data, encoding: String.Encoding.utf8) as String!
        shiftLogsRef.child("ShiftLogs").setValue(dataString)
    }
    
    func restoreUserShiftLogs(_ handler:@escaping ((_ data: Data?) -> Void) ){
        let shiftLogsRef = Database.database().reference(withPath: ApiConfig.firstNameYiSHA1)
        shiftLogsRef.child("ShiftLogs").observeSingleEvent(of: .value, with: { (snapshot) in
            let dataString = snapshot.value as! String
            handler(dataString.data(using: String.Encoding.utf8))
        })
    }
}

