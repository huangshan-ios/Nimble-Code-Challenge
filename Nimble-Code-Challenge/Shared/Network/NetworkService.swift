//
//  NetworkService.swift
//  Nimble-Code-Challenge
//
//  Created by Son Hoang on 24/06/2022.
//

import RxSwift

protocol NetworkService {
    func request<T: Decodable>(_ request: NimbleSurveyAPI) -> Single<T>
}