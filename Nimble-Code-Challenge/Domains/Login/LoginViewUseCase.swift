//
//  LoginViewUseCase.swift
//  Nimble-Code-Challenge
//
//  Created by Son Hoang on 25/06/2022.
//

import RxSwift

struct LoginResponseDTO: Decodable {
    
}

protocol LoginViewUseCase {
    var credentialRepository: CredentialRepository { get }
    
    func login(with email: String, and password: String) -> Single<Void>
}

final class LoginViewUseCaseImpl: LoginViewUseCase {
    let credentialRepository: CredentialRepository
    
    init(credentialRepository: CredentialRepository) {
        self.credentialRepository = credentialRepository
    }
    
    func login(with email: String, and password: String) -> Single<Void> {
        return .just(())
    }
}
