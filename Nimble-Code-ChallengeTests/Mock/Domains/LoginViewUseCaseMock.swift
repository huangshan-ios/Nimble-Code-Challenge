//
//  LoginViewUseCaseMock.swift
//  Nimble-Code-ChallengeTests
//
//  Created by Son Hoang on 27/06/2022.
//

import RxSwift

@testable import Nimble_Code_Challenge

final class LoginViewUseCaseMock: LoginViewUseCase, Mockable {
    
    let credentialRepository: CredentialRepository
    
    init(credentialRepository: CredentialRepository) {
        self.credentialRepository = credentialRepository
    }
    
    var listMock: [MockType] = []
    
    enum MockType {
        case login(Result<Bool, Error>)
        
        enum Case {
            case login
        }
        
        var `case`: Case {
            switch self {
            case .login: return .login
            }
        }
    }
    
    func login(with email: String, and password: String) -> Single<Bool> {
        guard let mock = listMock.first(where: { $0.case == .login }) else {
            return .error(APIError.somethingWentWrong)
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
