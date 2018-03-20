//
//  ApiClient.swift
//  ShiftLog
//
//  Created by Yi JIANG on 18/3/18.
//  Copyright © 2018 Siphty. All rights reserved.
//

import Foundation
import RxSwift
//import RxCocoa
import Alamofire

class ApiClient: ApiService {
    
    func postRestfulApi(_ config: ApiConfig, body: Data) -> Observable<RequestStatus> {
        return Observable<RequestStatus>.create { observable -> Disposable in
            self.networkRequest(config, body: body, completionHandler: { (data, error) in
                guard let data = data else {
                    if let error = error {
                        observable.onNext(RequestStatus.fail(RequestError(error.errorDescription ?? "Unknown Error")))
                    } else {
                        observable.onNext(RequestStatus.fail(RequestError("Parse JSON information failed without error.")))
                    }
                    observable.onCompleted()
                    return
                }
                observable.onNext(RequestStatus.success(data))
                observable.onCompleted()
            })
            return Disposables.create()
            }.share()
    }
    
    func fetchRestfulApi(_ config: ApiConfig) -> Observable<RequestStatus> {
        return Observable<RequestStatus>.create { observable -> Disposable in
            self.networkRequest(config, body:nil , completionHandler: { (data, error) in
                guard let data = data else {
                    if let error = error {
                        observable.onNext(RequestStatus.fail(RequestError(error.errorDescription ?? "Unknown Error")))
                    } else {
                        observable.onNext(RequestStatus.fail(RequestError("Parse JSON information failed without error.")))
                    }
                    observable.onCompleted()
                    return
                }
                observable.onNext(RequestStatus.success(data))
                observable.onCompleted()
            })
            return Disposables.create()
            }.share()
    }
    
    func networkRequest(_ config: ApiConfig, body: Data?, completionHandler: @escaping ((Data?, RequestError?) -> Void)) {
        networkRequestByAlamoFire(config, body:body, completionHandler: completionHandler)
        //        networkRequestByNSURLSession(config, completionHandler: completionHandler)
    }
}

// Other Network request methods and Response handler
extension ApiClient {
    
    func networkRequestByAlamoFire(_ config: ApiConfig, body: Data?, completionHandler: @escaping ((_ data: Data?, _ error: RequestError?) -> Void)) {
        URLCache.shared.removeAllCachedResponses()
        guard let url = config.getFullUrl() else {
            print("URL is nil, can't request.")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = config.method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let header = config.header {
            request.allHTTPHeaderFields = header
        }
        request.httpBody = body
        
        Alamofire.request(request).responseData { (response) in
            guard let data = response.result.value else {
                print("Error: \(String(describing: response.result.error))")
                completionHandler(nil, RequestError((response.result.error?.localizedDescription)!))
                return
            }
            completionHandler(data, nil)
        }
    }
    
    func networkRequestByNSURLSession(_ config: ApiConfig,_ completionHandler: @escaping ((_ data: Data?, _ error: RequestError?) -> Void)) {
        URLCache.shared.removeAllCachedResponses()
        guard let url = config.getFullUrl() else {
            print("URL is nil. Can't request.")
            return
        }
        let session = URLSession.shared
        let task = session.dataTask(with: url) { (data, response, error) in
            self.responseHandler(data, error, completionHandler)
        }
        task.resume()
    }
    
    fileprivate func responseHandler(_ data: Data?, _ error: Error?, _ completionHandler: @escaping ((_ data: Data?, _ error: RequestError?) -> Void)){
        completionHandler(data, RequestError(error?.localizedDescription ?? "Error with no message"))
    }
}
