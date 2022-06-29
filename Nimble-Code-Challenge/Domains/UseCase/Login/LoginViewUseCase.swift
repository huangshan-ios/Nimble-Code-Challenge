//
//  LoginViewUseCase.swift
//  Nimble-Code-Challenge
//
//  Created by Son Hoang on 25/06/2022.
//

import RxSwift

protocol LoginViewUseCase {
    var credentialRepository: CredentialRepository { get }
    
    func login(with email: String, and password: String) -> Single<Bool>
}

final class LoginViewUseCaseImpl: LoginViewUseCase {
    let credentialRepository: CredentialRepository
    
    init(credentialRepository: CredentialRepository) {
        self.credentialRepository = credentialRepository
    }
    
    func login(with email: String, and password: String) -> Single<Bool> {
        return credentialRepository.login(with: email, and: password)
            .map { _ in return true}
    }
}
