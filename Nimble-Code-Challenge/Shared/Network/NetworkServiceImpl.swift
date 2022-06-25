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
                default:
                    throw NetworkAPIError.getError(from: response.statusCode, data: response.data)
                }
            })
            .map(T.self)
    }
}
