//
//  NimbleNetworkServiceImpl.swift
//  Nimble-Code-Challenge
//
//  Created by Son Hoang on 24/06/2022.
//

import RxSwift
import Moya
import ObjectMapper

class NimbleNetworkServiceImpl: BaseService<NimbleSurveyAPI>, NimbleNetworkService {
    func request<T>(_ request: NimbleSurveyAPI, type: T.Type) -> Single<T> where T: Mappable {
        return _request(request)
            .map { response in
                if let jsonString = String(data: response.data,
                                           encoding: .utf8),
                   let object = T(JSONString: jsonString) {
                    return object
                }
                throw APIErrorDTO.somethingWentWrong
            }
    }
}
