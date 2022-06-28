//
//  CredentialRepository.swift
//  Nimble-Code-Challenge
//
//  Created by Son Hoang on 25/06/2022.
//

import RxSwift

protocol CredentialRepository {
    var networkService: NetworkService { get }
    
    func login(with email: String, and password: String) -> Single<Result<CredentialDTO, Error>>
}

final class CredentialRepositoryImpl: CredentialRepository {
    let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func login(with email: String, and password: String) -> Single<Result<CredentialDTO, Error>> {
        let request: Single<DataResponseDTO<CredentialDTO>> = networkService.request(.login(email, password))
        return request
            .map { dataResponse in
                return .success(dataResponse.data)
            }.catch({ error in
                return .just(.failure(error))
            })
    }
}
