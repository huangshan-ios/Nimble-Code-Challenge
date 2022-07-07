//
//  SurveyRepository.swift
//  Nimble-Code-Challenge
//
//  Created by Son Hoang on 30/06/2022.
//

import RxSwift
import JSONAPIMapper

protocol SurveyRepository {
    var networkService: NimbleNetworkService { get }
    
    func fetchSurveys(in page: Int, with size: Int) -> Single<([SurveyDTO], MetaDTO)>
    func getDetailSurvey(_ surveyId: String) -> Single<DataSurveyDetailDTO>
}

final class SurveyRepositoryImpl: SurveyRepository {
    let networkService: NimbleNetworkService
    
    init(networkService: NimbleNetworkService) {
        self.networkService = networkService
    }
    
    func fetchSurveys(in page: Int, with size: Int) -> Single<([SurveyDTO], MetaDTO)> {
        return networkService.request(.surveys(page, size), type: [SurveyDTO].self, metaType: MetaDTO.self)
    }
    
    func getDetailSurvey(_ surveyId: String) -> Single<DataSurveyDetailDTO> {
        return networkService.request(.surveyDetail(surveyId), type: DataSurveyDetailDTO.self)
    }
}
