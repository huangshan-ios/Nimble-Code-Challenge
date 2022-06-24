//
//  NimbleSurveyAPITargetType.swift
//  Nimble-Code-Challenge
//
//  Created by Son Hoang on 24/06/2022.
//

import Moya

extension NimbleSurveyAPI: TargetType {
    var baseURL: URL {
        return URL(string: AppConstants.baseURL)!
    }
    
    var path: String {
        switch self {
        case .login:
            return ""
        }
    }
    
    var method: Method {
        switch self {
        case .login:
            return .post
        }
    }
    
    var paramaters: [String: String] {
        switch self {
        case .login(let userName, let password):
            return ["userName": userName, "password": password]
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    var task: Task {
        return .requestParameters(parameters: paramaters, encoding: parameterEncoding)
    }
    
    var headers: [String: String]? {
        return [:]
    }
    
}
