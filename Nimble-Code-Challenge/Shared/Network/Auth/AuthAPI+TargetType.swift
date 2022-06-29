//
//  AuthAPI+TargetType.swift
//  Nimble-Code-Challenge
//
//  Created by Son Hoang on 29/06/2022.
//

import Moya

extension AuthAPI: TargetType {
    var baseURL: URL {
        return URL(string: AppConstants.baseURL)!
    }
    
    var path: String {
        return "oauth/token"
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var paramaters: [String: String] {
        let refreshToken = UserSession.shared.getCredential().attributes.refreshToken
        return ["grant_type": "refresh_token",
                "refresh_token": refreshToken,
                "client_id": "ofzl-2h5ympKa0WqqTzqlVJUiRsxmXQmt5tkgrlWnOE",
                "client_secret": "lMQb900L-mTeU-FVTCwyhjsfBwRCxwwbCitPob96cuU"]
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
