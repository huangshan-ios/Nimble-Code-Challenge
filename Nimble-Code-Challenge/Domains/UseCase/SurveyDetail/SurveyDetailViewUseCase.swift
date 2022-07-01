//
//  SurveyDetailViewUseCase.swift
//  Nimble-Code-Challenge
//
//  Created by Son Hoang on 01/07/2022.
//

import RxSwift

protocol SurveyDetailViewUseCase {
    var surveyRepository: SurveyRepository { get }
    
    func getSurveyDetail(_ surveyId: String) -> Single<DataSurveyDetailDTO>
}

final class SurveyDetailViewUseCaseImpl: SurveyDetailViewUseCase {
    let surveyRepository: SurveyRepository
    
    init(surveyRepository: SurveyRepository) {
        self.surveyRepository = surveyRepository
    }
    
    func getSurveyDetail(_ surveyId: String) -> Single<DataSurveyDetailDTO> {
        return surveyRepository.getDetailSurvey(surveyId)
    }
}
