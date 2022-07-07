//
//  NetworkServiceMock.swift
//  Nimble-Code-ChallengeTests
//
//  Created by Son Hoang on 29/06/2022.
//

import RxSwift
import JSONAPIMapper

@testable import Nimble_Code_Challenge

final class NetworkServiceMock: NimbleNetworkService, Mockable {

    var listMock: [MockType] = []
    
    typealias MockType = Result<String, ErrorTypeMock>
    
    func request<T>(_ request: NimbleSurveyAPI, type: T.Type) -> Single<T> where T: Decodable {
        guard let mock = listMock.first else {
            return .error(APIError.somethingWentWrong)
        }
        
        switch mock {
        case .success(let fileName):
            let response = loadJSON(filename: fileName, type: T.self)
            return .just(response)
        case .failure(let errorType):
            switch errorType {
            case .json(let fileName):
                do {
                    let _ = try loadError(filename: fileName)
                } catch let error {
                    return .error(error)
                }
                return .error(APIError.somethingWentWrong)
            case .error(let error):
                return .error(error)
            }
        }
    }
    
    func request<T, M>(_ request: NimbleSurveyAPI, type: T.Type, metaType: M.Type) -> Single<(T, M)> where T: Decodable, M: Decodable {
        guard let mock = listMock.first else {
            return .error(APIError.somethingWentWrong)
        }
        
        switch mock {
        case .success(let fileName):
            let response = loadJSON(filename: fileName, type: type, metaType: metaType)
            return .just(response)
        case .failure(let errorType):
            switch errorType {
            case .json(let fileName):
                do {
                    let _ = try loadError(filename: fileName)
                } catch let error {
                    return .error(error)
                }
                return .error(APIError.somethingWentWrong)
            case .error(let error):
                return .error(error)
            }
        }
    }
}
