//
//  NetworkServiceMock.swift
//  Nimble-Code-ChallengeTests
//
//  Created by Son Hoang on 29/06/2022.
//

import RxSwift

@testable import Nimble_Code_Challenge

final class NetworkServiceMock: NetworkService, Mockable {
    
    var listMock: [MockType] = []
    
    enum MockType {
        case login(Result<DataTypeMock, Error>)
        
        enum Case {
            case login
        }
        
        var `case`: Case {
            switch self {
            case .login: return .login
            }
        }
    }
    
    func request<T>(_ request: NimbleSurveyAPI) -> Single<Result<T, Error>> where T: Decodable {
        guard let mock = listMock.first(where: { $0.case == .login }) else {
            return .just(.failure(NetworkAPIError.unknown))
        }
        
        switch mock {
        case .login(let result):
            switch result {
            case .success(let dataType):
                switch dataType {
                case .json(let fileName):
                    let object = loadJSON(filename: fileName, type: T.self)
                    return .just(.success(object))
                case .object(let object):
                    guard let object = object as? T else {
                        return .just(.failure(NetworkAPIError.unknown))
                    }
                    return .just(.success(object))
                }
            case .failure(let error):
                return .just(.failure(error))
            }
        }
    }
}
