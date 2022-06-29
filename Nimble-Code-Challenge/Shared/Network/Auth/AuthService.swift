//
//  AuthService.swift
//  Nimble-Code-Challenge
//
//  Created by Son Hoang on 29/06/2022.
//

import Moya
import RxSwift

final class AuthService: BaseService<AuthAPI> {
    static let shared = AuthService()
    
    func renewalToken() -> Single<Response> {
        return _request(.renewalToken)
    }
}
