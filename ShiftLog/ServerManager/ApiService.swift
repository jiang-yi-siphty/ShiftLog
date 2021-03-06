//
//  ApiService.swift
//  ShiftLog
//
//  Created by Yi JIANG on 18/3/18.
//  Copyright © 2018 Siphty. All rights reserved.
//

import Foundation
import RxSwift
//import RxCocoa

enum RequestStatus {
    case success(Data?)
    case fail(RequestError)
}

struct RequestError : LocalizedError {
    var errorDescription: String? { return mMsg }
    var failureReason: String? { return mMsg }
    var recoverySuggestion: String? { return "" }
    var helpAnchor: String? { return "" }
    private var mMsg : String
    
    init(_ description: String) {
        mMsg = description
    }
}

enum  ApiConfig {
    case bussiness
    case startShift
    case endShift
    case shiftLogs
    
    fileprivate static let shiftLogBaseUrl = "https://apjoqdqpi3.execute-api.us-west-2.amazonaws.com/dmc"
    public static let firstNameYiSHA1 = "48b3f8cdcb1b705653ad2d03a86591a505d38596"
    
    var urlPath: String {
        switch self {
        case .bussiness:
            return "/business"
        case .startShift:
            return "/shift/start"
        case .endShift:
            return "/shift/end"
        case .shiftLogs:
            return "/shifts"
        }
    }
    
    var method: String {
        switch self {
        case .bussiness:
            return "GET"
        case .startShift:
            return "POST"
        case .endShift:
            return "POST"
        case .shiftLogs:
            return "GET"
        }
    }
    
    var header: [String: String]?{
        switch self {
        case .bussiness, .startShift, .endShift, .shiftLogs:
            return ["Authorization": "Deputy " + ApiConfig.firstNameYiSHA1]
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .bussiness, .startShift, .endShift, .shiftLogs:
            return nil
        }
    }
    
    func getFullUrl() -> URL? {
        var baseUrl: String!
        switch self {
        case .bussiness, .startShift, .endShift, .shiftLogs:
            baseUrl = ApiConfig.shiftLogBaseUrl
        }
        if let url = URL(string: baseUrl + self.urlPath)  {
            return url
        } else {
            print("could not open url, it was nil")
        }
        return nil
    }
}

protocol ApiService {
    func postRestfulApi(_ config: ApiConfig, body: Data) -> Observable<RequestStatus>
    func fetchRestfulApi(_ config: ApiConfig) -> Observable<RequestStatus>
    func networkRequest(_ config: ApiConfig, body: Data?, completionHandler: @escaping ((Data?, RequestError?) -> Void))
}

