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
        case .login, .refreshToken:
            return "oauth/token"
        }
    }
    
    var method: Method {
        switch self {
        case .login, .refreshToken:
            return .post
        }
    }
    
    var paramaters: [String: String] {
        var paramaters: [String: String] = ["client_id": "ofzl-2h5ympKa0WqqTzqlVJUiRsxmXQmt5tkgrlWnOE",
                                            "client_secret": "lMQb900L-mTeU-FVTCwyhjsfBwRCxwwbCitPob96cuU"]
        switch self {
        case .login(let email, let password):
            paramaters["grant_type"] = "password"
            paramaters["email"] = email
            paramaters["password"] = password
        case .refreshToken(let refreshToken):
            paramaters["grant_type"] = "refresh_token"
            paramaters["refresh_token"] = refreshToken
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
        case .login, .refreshToken:
            return headers
        default:
            let credential = UserSession.shared.getCredential()
            if !credential.attributes.accessToken.isEmpty {
                headers["Authentication"] = "\(credential.attributes.tokenType) \(credential.attributes.accessToken)"
            }
        }
        return headers
    }
    
}
