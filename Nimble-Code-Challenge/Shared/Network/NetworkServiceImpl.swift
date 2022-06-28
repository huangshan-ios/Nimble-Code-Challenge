//
//  NetworkServiceImpl.swift
//  Nimble-Code-Challenge
//
//  Created by Son Hoang on 24/06/2022.
//

import RxSwift
import Moya

enum TokenError: Error {
    case tokenExpired
}

class NetworkServiceImpl: NetworkService {
    func request<T>(_ token: NimbleSurveyAPI) -> Single<T> where T: Decodable {
        return nimbleSurveyProvider.rx.request(token)
            .map({ response in
                switch response.statusCode {
                case 200...299:
                    do {
                        let dtoResponse = try JSONDecoder().decode(T.self, from: response.data)
                        return dtoResponse
                    } catch {
                        throw NetworkAPIError.unknown
                    }
                case 401:
                    let isCredentialRequest = (response.request?.url?.path ?? "").contains("token")
                    if isCredentialRequest {
                        throw NetworkAPIError.getError(from: response.statusCode, data: response.data)
                    } else {
                        throw TokenError.tokenExpired
                    }
                default:
                    throw NetworkAPIError.getError(from: response.statusCode, data: response.data)
                }
            })
            .retry(when: { (error: Observable<TokenError>) in
                error.flatMap { error -> Single<()> in
                    switch error {
                    case .tokenExpired:
                        let token = UserSession.shared.getCredential().attributes.refreshToken
                        return nimbleSurveyProvider.rx.request(.refreshToken(token))
                            .flatMap { response in
                                switch response.statusCode {
                                case 200:
                                    return .just(())
                                default:
                                    return .just(())
                                }
                            }
                    }
                }
            }).retry(2)
    }
}
