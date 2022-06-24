//
//  NetworkServiceImpl.swift
//  Nimble-Code-Challenge
//
//  Created by Son Hoang on 24/06/2022.
//

import RxSwift
import Moya

class NetworkServiceImpl: NetworkService {
    func request<T>(_ token: NimbleSurveyAPI) -> Single<T> where T: Decodable {
        return nimbleSurveyProvider.rx.request(token)
            .flatMap({ response in
                switch response.statusCode {
                case 200...299:
                    return .just(response)
                case 304:
                    throw NetworkAPIError.notModified
                case 401:
                    throw NetworkAPIError.unauthorized
                case 403:
                    throw NetworkAPIError.accessDenied
                case 404:
                    throw NetworkAPIError.notFound
                case 405:
                    throw NetworkAPIError.methodNotAllowed
                case 422:
                    throw NetworkAPIError.validate
                case 500:
                    throw NetworkAPIError.serverError
                case 502:
                    throw NetworkAPIError.badGateway
                case 503:
                    throw NetworkAPIError.serviceUnavailable
                case 504:
                    throw NetworkAPIError.gatewayTimeout
                default:
                    throw NetworkAPIError.unknown(statusCode: response.statusCode,
                                                  data: response.data)
                }
            })
            .map(T.self)
    }
}
