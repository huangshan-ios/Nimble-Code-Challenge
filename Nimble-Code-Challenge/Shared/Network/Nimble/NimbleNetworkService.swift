//
//  NimbleNetworkService.swift
//  Nimble-Code-Challenge
//
//  Created by Son Hoang on 29/06/2022.
//

import RxSwift

protocol NimbleNetworkService {
    func request<T: Decodable>(_ request: NimbleSurveyAPI, type: T.Type) -> Single<T>
}
