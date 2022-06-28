//
//  CredentialRepository.swift
//  Nimble-Code-Challenge
//
//  Created by Son Hoang on 25/06/2022.
//

import RxSwift

protocol CredentialRepository {
    var networkService: NetworkService { get }
    
    func login(with email: String, and password: String) -> Single<CredentialDTO>
}

final class CredentialRepositoryImpl: CredentialRepository {
    let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func login(with email: String, and password: String) -> Single<CredentialDTO> {
        return networkService.request(.login(email, password), type: DataResponseDTO.self)
            .map({ $0.data })
    }
}
