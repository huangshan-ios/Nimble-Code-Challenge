//
//  NetworkServiceMock.swift
//  Nimble-Code-ChallengeTests
//
//  Created by Son Hoang on 29/06/2022.
//

import RxSwift
import ObjectMapper

@testable import Nimble_Code_Challenge

final class NetworkServiceMock: NimbleNetworkService, Mockable {
    
    var listMock: [MockType] = []
    
    typealias MockType = Result<DataTypeMock, ErrorTypeMock>
    
    func request<T>(_ request: NimbleSurveyAPI, type: T.Type) -> Single<T> where T: Mappable {
        guard let mock = listMock.first else {
            return .error(APIErrorDTO.somethingWentWrong)
        }
        
        switch mock {
        case .success(let dataType):
            switch dataType {
            case .json(let fileName):
                let object = loadJSON(filename: fileName, type: T.self)
                return .just(object)
            case .object(let object):
                guard let object = object as? T else {
                    return .error(APIErrorDTO.somethingWentWrong)
                }
                return .just(object)
            }
        case .failure(let errorType):
            switch errorType {
            case .json(let fileName):
                let error = loadJSON(filename: fileName, type: APIErrorDTO.self)
                return .error(error)
            case .error(let error):
                return .error(error)
            }
        }
    }
}
