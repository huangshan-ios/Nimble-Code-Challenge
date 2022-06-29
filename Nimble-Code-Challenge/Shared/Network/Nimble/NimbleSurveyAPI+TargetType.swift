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
            return "oauth/token"
        case .surveys:
            return "surveys"
        }
    }
    
    var method: Method {
        switch self {
        case .login:
            return .post
        case .surveys:
            return .get
        }
    }
    
    var paramaters: [String: String] {
        var paramaters: [String: String] = [:]
        switch self {
        case .login(let email, let password):
            paramaters["client_secret"] = "lMQb900L-mTeU-FVTCwyhjsfBwRCxwwbCitPob96cuU"
            paramaters["client_id"] = "ofzl-2h5ympKa0WqqTzqlVJUiRsxmXQmt5tkgrlWnOE"
            paramaters["grant_type"] = "password"
            paramaters["email"] = email
            paramaters["password"] = password
        case .surveys:
            return paramaters
        }
        return paramaters
    }
    
    var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    var task: Task {
        return .requestParameters(parameters: paramaters, encoding: parameterEncoding)
    }
    
    var headers: [String: String]? {
        var headers: [String: String] = [:]
        switch self {
        case .login:
            return headers
        default:
            let credential = UserSession.shared.getCredential()
            if !credential.attributes.accessToken.isEmpty {
                headers["Authorization"] = "\(credential.attributes.tokenType) \(credential.attributes.accessToken)"
            }
        }
        return headers
    }
    
}
