//
//  HomeViewUseCase.swift
//  Nimble-Code-Challenge
//
//  Created by Son Hoang on 30/06/2022.
//

import RxSwift
import JSONAPIMapper

protocol HomeViewUseCase {
    var surveyRepository: SurveyRepository { get }
    
    func fetchSurveys(in page: Int, with size: Int) -> Single<DataSurvey>
}

final class HomeViewUseCaseImpl: HomeViewUseCase {
    let surveyRepository: SurveyRepository
    
    init(surveyRepository: SurveyRepository) {
        self.surveyRepository = surveyRepository
    }
    
    func fetchSurveys(in page: Int, with size: Int) -> Single<DataSurvey> {
        return surveyRepository.fetchSurveys(in: page, with: size)
            .map({ result in
                return DataSurvey(data: result.0.map { $0.toSurvey() }, meta: result.1.toMeta())
            })
    }
}
