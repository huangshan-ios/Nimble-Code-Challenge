//
//  LoginViewUseCase.swift
//  Nimble-Code-Challenge
//
//  Created by Son Hoang on 25/06/2022.
//

import RxSwift

protocol LoginViewUseCase {
    var credentialRepository: CredentialRepository { get }
    
    func login(with email: String, and password: String) -> Single<Result<Void, AppError>>
}

final class LoginViewUseCaseImpl: LoginViewUseCase {
    let credentialRepository: CredentialRepository
    
    init(credentialRepository: CredentialRepository) {
        self.credentialRepository = credentialRepository
    }
    
    func login(with email: String, and password: String) -> Single<Result<Void, AppError>> {
        return credentialRepository.login(with: email, and: password)
            .map { result in
                switch result {
                case .success(let loginDTO):
                    UserSession.shared.setCredential(loginDTO.toCredentials())
                    return .success(())
                case .failure(let error):
                    return .failure(error.mapToAppError())
                }
            }
    }
}
