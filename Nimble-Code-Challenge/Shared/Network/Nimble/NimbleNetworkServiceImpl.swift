//
//  NimbleNetworkServiceImpl.swift
//  Nimble-Code-Challenge
//
//  Created by Son Hoang on 24/06/2022.
//

import RxSwift
import Moya
import JSONAPIMapper

class NimbleNetworkServiceImpl: BaseService<NimbleSurveyAPI>, NimbleNetworkService {
    func request<T>(_ request: NimbleSurveyAPI, type: T.Type) -> Single<T> where T: Decodable {
        return _request(request).map { response in
            return try JSONAPIDecoder().decode(type, from: response.data)
        }
    }
    
    func request<T, M>(_ request: NimbleSurveyAPI, type: T.Type, metaType: M.Type) -> Single<(T, M)> where T: Decodable, M: Decodable {
        return _request(request).map { response in
            do {
                let response = try JSONAPIDecoder().decodeWithMeta(value: type, meta: metaType, from: response.data)
                return response
            } catch let error {
                print("Error \(error)")
                throw error
            }
        }
    }
}
