//
//  ApiService.swift
//  ShiftLog
//
//  Created by Yi JIANG on 18/3/18.
//  Copyright © 2018 Siphty. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum RequestStatus {
    case success(AnyObject?)
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
    case shifts
    
    fileprivate static let shiftLogsBaseUrl = "https://apjoqdqpi3.execute­api.us­west­2.amazonaws.com/dmc"
    
    var urlPath: String {
        switch self {
        case .bussiness:
            return "/business"
        case .startShift:
            return "/shift/start"
        case .endShift:
            return "/shift/end"
        case .shifts:
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
        case .shifts:
            return "GET"
        }
    }
    
    var header: [String: Any]?{
        switch self {
        case .bussiness, .startShift, .endShift, .shifts:
            return ["Authorization": "Deputy " + "d82ece8d514aca7e24d3fc11fbb8dada57f2966c"]
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .bussiness, .startShift, .endShift, .shifts:
            return nil
        }
    }
    
    func getFullUrl() -> URL {
        var baseUrl: String!
        switch self {
        case .bussiness, .startShift, .endShift, .shifts:
            baseUrl = ApiConfig.shiftLogsBaseUrl
        }
        if let url = URL(string: baseUrl + self.urlPath)  {
            return url
        } else {
            return URL(string: baseUrl)!
        }
    }
}

protocol ApiService {
    func fetchRestfulApi(_ config: ApiConfig) -> Observable<RequestStatus>
    func networkRequest(_ config: ApiConfig, completionHandler: @escaping ((_ jsonResponse: [String: Any]?, _ error: RequestError?) -> Void))
}

