//
//  SurveyRepository.swift
//  Nimble-Code-Challenge
//
//  Created by Son Hoang on 30/06/2022.
//

import RxSwift

protocol SurveyRepository {
    var networkService: NimbleNetworkService { get }
    
    func fetchSurveys() -> Single<DataSurveyDTO>
    func getDetailSurvey(_ surveyId: String) -> Single<DataSurveyDetailDTO>
}

final class SurveyRepositoryImpl: SurveyRepository {
    let networkService: NimbleNetworkService
    
    init(networkService: NimbleNetworkService) {
        self.networkService = networkService
    }
    
    func fetchSurveys() -> Single<DataSurveyDTO> {
        return networkService.request(.surveys, type: DataSurveyDTO.self)
    }
    
    func getDetailSurvey(_ surveyId: String) -> Single<DataSurveyDetailDTO> {
        return networkService.request(.surveyDetail(surveyId), type: DataSurveyDetailDTO.self)
    }
}
