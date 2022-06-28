//
//  CredentialRepositoryMock.swift
//  Nimble-Code-ChallengeTests
//
//  Created by Son Hoang on 28/06/2022.
//

import RxSwift

@testable import Nimble_Code_Challenge

final class CredentialRepositoryMock: CredentialRepository, Mockable {
    let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    var listMock: [MockType] = []
    
    enum MockType {
        case login(Result<CredentialDTO, Error>)
        
        enum Case {
            case login
        }
        
        var `case`: Case {
            switch self {
            case .login: return .login
            }
        }
    }
    
    func login(with email: String, and password: String) -> Single<Result<CredentialDTO, Error>> {
        guard let mock = listMock.first(where: { $0.case == .login }) else {
            return .just(.failure(AppError.somethingWentWrong))
        }
        
        switch mock {
        case .login(let result):
            return .just(result)
        }
    }
    
}
