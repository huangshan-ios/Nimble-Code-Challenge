//
//  HomeViewUseCase.swift
//  Nimble-Code-Challenge
//
//  Created by Son Hoang on 30/06/2022.
//

import RxSwift

protocol HomeViewUseCase {
    var surveyRepository: SurveyRepository { get }
    
    func fetchSurveys() -> Single<[Survey]>
}

final class HomeViewUseCaseImpl: HomeViewUseCase {
    let surveyRepository: SurveyRepository
    
    init(surveyRepository: SurveyRepository) {
        self.surveyRepository = surveyRepository
    }
    
    func fetchSurveys() -> Single<[Survey]> {
        return surveyRepository.fetchSurveys()
            .map { response in
                return response.data.map { $0.toSurvey() }
            }
    }
}
