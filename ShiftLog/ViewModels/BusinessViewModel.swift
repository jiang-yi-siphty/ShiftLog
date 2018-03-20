//
//  BusinessViewModel.swift
//  ShiftLog
//
//  Created by Yi JIANG on 19/3/18.
//  Copyright © 2018 Siphty. All rights reserved.
//

import Foundation
import RxSwift
import Firebase

class BusinessViewModel {
    
    let disposeBag = DisposeBag()
    var business = Variable<Business?>(nil)
    var businessName = Variable<String?>(nil)
    var businessLogo = Variable<String?>(nil)
    var isFetchingData = Variable<Bool>(false)
    var isAlertShowing = Variable<Bool>(false)
    private var apiService: ApiService? = nil

    init(_ apiService: ApiService) {
        bindBusiness()
        fetchBusiness(apiService)
        self.apiService = apiService
    }
    
    func updateBusiness(){
        guard let apiService = self.apiService else { return }
        fetchBusiness(apiService)
    }
    
    fileprivate func fetchBusiness(_ apiService: ApiService) {
        self.isFetchingData.value = true
        apiService.fetchRestfulApi(ApiConfig.bussiness)
            .subscribe(onNext: { status in
                self.isFetchingData.value = false
                switch status {
                case .success(let data):
                    guard let data = data else { return }
                    do {
                        self.business.value = try JSONDecoder().decode(Business.self, from: data)
                        self.isAlertShowing.value = false
                    } catch {
                        self.business.value = nil
                        self.isAlertShowing.value = true
                    }
                    self.storeBusiness(data)
                case .fail(let error):
                    self.restoreBusiness({ data in
                        guard let data = data else { return }
                        do {
                            self.business.value = try JSONDecoder().decode(Business.self, from: data)
                            self.isAlertShowing.value = false
                        } catch {
                            self.business.value = nil
                            self.isAlertShowing.value = true
                        }
                    })
                    print(error.errorDescription ?? "Faild to load Scenic Location data")
                }
            }, onError: { error in
                self.restoreBusiness({ data in
                    guard let data = data else { return }
                    do {
                        self.business.value = try JSONDecoder().decode(Business.self, from: data)
                        self.isAlertShowing.value = false
                    } catch {
                        self.business.value = nil
                        self.isAlertShowing.value = true
                    }
                })
            }, onCompleted: nil, onDisposed: nil)
            .disposed(by: disposeBag)
    }
    
    fileprivate func bindBusiness() {
        business.asObservable()
            .subscribe(onNext: { (business) in
                self.businessName.value = business?.name
                self.businessLogo.value = business?.logo
            }, onError: { (error) in
                print("error: \(error.localizedDescription)")
            }, onCompleted: nil, onDisposed: nil)
            .disposed(by: disposeBag)
    }
}


//Firebase DB / Offline DB
extension BusinessViewModel {
    func storeBusiness(_ data: Data) {
        let businessRef = Database.database().reference(withPath: "\(ApiConfig.firstNameYiSHA1)")
        let dataString = String(data: data, encoding: String.Encoding.utf8) as String!
        businessRef.child("BusinessDetails").setValue(dataString)
    }
    
    func restoreBusiness(_ handler:@escaping ((_ data: Data?) -> Void) ){
        let businessRef = Database.database().reference(withPath: "\(ApiConfig.firstNameYiSHA1)")
        businessRef.child("BusinessDetails").observeSingleEvent(of: .value, with: { (snapshot) in
            let dataString = snapshot.value as! String
            handler(dataString.data(using: String.Encoding.utf8))
        })
    }
}
