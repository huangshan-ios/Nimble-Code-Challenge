//
//  NimbleNetworkServiceImpl.swift
//  Nimble-Code-Challenge
//
//  Created by Son Hoang on 24/06/2022.
//

import RxSwift
import Moya

class NimbleNetworkServiceImpl: BaseService<NimbleSurveyAPI>, NimbleNetworkService {
    func request<T>(_ request: NimbleSurveyAPI, type: T.Type) -> Single<T> where T: Decodable {
        return _request(request).map(type)
    }
}
