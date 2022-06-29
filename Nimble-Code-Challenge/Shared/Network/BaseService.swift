//
//  BaseService.swift
//  Nimble-Code-Challenge
//
//  Created by Son Hoang on 29/06/2022.
//

import Moya
import RxSwift

class BaseService<API: TargetType> {
    private let provider = BaseProvider<API>(plugins: [NetworkLoggerPlugin()])
    
    func _request(_ api: API) -> Single<Response> {
        return provider.rx.request(api)
            .flatMap { response in
                if response.statusCode == 401 {
                    throw TokenError.tokenExpired
                } else {
                    return .just(response)
                }
            }
            .retry { (error: Observable<TokenError>) in
                error.flatMap { error -> Single<Response> in
                    AuthService.shared.renewalToken()
                }
            }
            .handleResponse()
            .retry(2)
    }
}
