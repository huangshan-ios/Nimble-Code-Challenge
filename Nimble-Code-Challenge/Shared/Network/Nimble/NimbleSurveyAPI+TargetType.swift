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
    
    var paramaters: [String: Any] {
        var paramaters: [String: Any] = [:]
        switch self {
        case .login(let email, let password):
            paramaters["client_secret"] = AppConstants.clientSecret
            paramaters["client_id"] = AppConstants.clientId
            paramaters["grant_type"] = "password"
            paramaters["email"] = email
            paramaters["password"] = password
            return paramaters
        case .surveys(let pageNumber, let pageSize):
            paramaters["page[number]"] = pageNumber
            paramaters["page[size]"] = pageSize
            return paramaters
        default:
            return paramaters
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .login, .surveyDetail:
            return URLEncoding.default
        case .surveys:
            return URLEncoding.queryString
        }
    }
    
    var task: Task {
        return .requestParameters(parameters: paramaters, encoding: parameterEncoding)
    }
    
    var headers: [String: String]? {
        return [:]
    }
}
