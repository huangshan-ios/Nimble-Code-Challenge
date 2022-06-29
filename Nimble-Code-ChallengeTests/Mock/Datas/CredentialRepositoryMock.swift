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
    
    func login(with email: String, and password: String) -> Single<CredentialDTO> {
        guard let mock = listMock.first(where: { $0.case == .login }) else {
            return .error(APIErrorDTO.somethingWentWrong)
        }
        
        switch mock {
        case .login(let result):
            switch result {
            case .success(let success):
                return .just(success)
            case .failure(let error):
                return .error(error)
            }
        }
    }
    
}
