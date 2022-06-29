//
//  CredentialRepository.swift
//  Nimble-Code-Challenge
//
//  Created by Son Hoang on 25/06/2022.
//

import RxSwift

protocol CredentialRepository {
    var networkService: NimbleNetworkService { get }
    
    func login(with email: String, and password: String) -> Single<CredentialDTO>
}

final class CredentialRepositoryImpl: CredentialRepository {
    let networkService: NimbleNetworkService
    
    init(networkService: NimbleNetworkService) {
        self.networkService = networkService
    }
    
    func login(with email: String, and password: String) -> Single<CredentialDTO> {
        return networkService.request(.login(email, password), type: DataResponseDTO.self)
            .map({ $0.data })
    }
}
