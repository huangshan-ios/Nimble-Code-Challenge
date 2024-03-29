//
//  CredentialRepositoryMock.swift
//  Nimble-Code-ChallengeTests
//
//  Created by Son Hoang on 28/06/2022.
//

import RxSwift

@testable import Nimble_Code_Challenge

final class CredentialRepositoryMock: CredentialRepository, Mockable {
    
    let networkService: NimbleNetworkService
    
    init(networkService: NimbleNetworkService) {
        self.networkService = networkService
    }
    
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
    
    func login(with email: String, and password: String) -> Single<CredentialDTO> {
        guard let mock = listMock.first(where: { $0.case == .login }) else {
            return .error(APIError.somethingWentWrong)
        }
        
        switch mock {
        case .login(let result):
            switch result {
            case .success(let dataType):
                switch dataType {
                case .json(let fileName):
                    let response = loadJSON(filename: fileName, type: CredentialDTO.self)
                    return .just(response)
                case .object(let object):
                    guard let response = object as? CredentialDTO else {
                        return .error(APIError.somethingWentWrong)
                    }
                    return .just(response)
                }
            case .failure(let error):
                return .error(error)
            }
        }
    }
    
}
