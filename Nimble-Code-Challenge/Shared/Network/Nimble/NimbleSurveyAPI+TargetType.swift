//
//  NimbleSurveyAPI+TargetType.swift
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
            return AppConstants.URL.authen
        case .surveys:
            return AppConstants.URL.surveys
        case .surveyDetail(let id):
            return "\(AppConstants.URL.surveys)/\(id)"
        }
    }
    
    var method: Method {
        switch self {
        case .login:
            return .post
        case .surveys, .surveyDetail:
            return .get
        }
    }
    
    var paramaters: [String: String] {
        var paramaters: [String: String] = [:]
        switch self {
        case .login(let email, let password):
            paramaters["client_secret"] = AppConstants.clientSecret
            paramaters["client_id"] = AppConstants.clientId
            paramaters["grant_type"] = "password"
            paramaters["email"] = email
            paramaters["password"] = password
            return paramaters
        default:
            return paramaters
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
