//
//  HomeViewUseCase.swift
//  Nimble-Code-Challenge
//
//  Created by Son Hoang on 30/06/2022.
//

import RxSwift

typealias SurveysResponse = (surveys: [Survey], meta: ResponseMeta?)

protocol HomeViewUseCase {
    var surveyRepository: SurveyRepository { get }
    
    func fetchSurveys(page: Int, size: Int) -> Single<SurveysResponse>
}

final class HomeViewUseCaseImpl: HomeViewUseCase {
    let surveyRepository: SurveyRepository
    
    init(surveyRepository: SurveyRepository) {
        self.surveyRepository = surveyRepository
    }
    
    func fetchSurveys(page: Int, size: Int) -> Single<SurveysResponse> {
        return surveyRepository.fetchSurveys(page: page, size: size)
            .map { response in
                let surveys = response.data.map { $0.toSurvey() }
                let meta = response.meta?.toResponseMeta()
                return (surveys: surveys, meta: meta)
            }
    }
}
