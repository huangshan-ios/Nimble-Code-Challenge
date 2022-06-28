//
//  CredentialRepository.swift
//  Nimble-Code-Challenge
//
//  Created by Son Hoang on 25/06/2022.
//

import RxSwift

protocol CredentialRepository {
    var networkService: NetworkService { get }
    
    func login(with email: String, and password: String) -> Single<Result<LoginDTO, Error>>
}

final class CredentialRepositoryImpl: CredentialRepository {
    let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func login(with email: String, and password: String) -> Single<Result<LoginDTO, Error>> {
        let dataResponse: Single<Result<DataResponseDTO<LoginDTO>, Error>> = networkService.request(.login(email, password))
        return dataResponse
            .map { result in
                switch result {
                case .success(let dataResponse):
                    return .success(dataResponse.data)
                case .failure(let error):
                    return .failure(error)
                }
            }
    }
}
