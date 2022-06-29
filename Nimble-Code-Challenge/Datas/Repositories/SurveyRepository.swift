//
//  SurveyRepository.swift
//  Nimble-Code-Challenge
//
//  Created by Son Hoang on 30/06/2022.
//

import RxSwift

protocol SurveyRepository {
    func fetchSurveys() -> Single<DataResponseDTO<[SurveyDTO]>>
}

final class SurveyRepositoryImpl: SurveyRepository {
    let networkService: NimbleNetworkService
    
    init(networkService: NimbleNetworkService) {
        self.networkService = networkService
    }
    
    func fetchSurveys() -> Single<DataResponseDTO<[SurveyDTO]>> {
        return networkService.request(.surveys, type: DataResponseDTO.self)
    }
}