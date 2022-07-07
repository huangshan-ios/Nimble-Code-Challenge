//
//  HomeViewUseCaseMock.swift
//  Nimble-Code-ChallengeTests
//
//  Created by Son Hoang on 01/07/2022.
//

import RxSwift

@testable import Nimble_Code_Challenge

final class HomeViewUseCaseMock: HomeViewUseCase, Mockable {
    let surveyRepository: SurveyRepository
    
    init(surveyRepository: SurveyRepository) {
        self.surveyRepository = surveyRepository
    }
    
    var listMock: [MockType] = []
    
    enum MockType {
        case surveys(Result<DataSurvey, Error>)
        
        enum Case {
            case surveys
        }
        
        var `case`: Case {
            switch self {
            case .surveys: return .surveys
            }
        }
    }
    
    func fetchSurveys(in page: Int, with size: Int) -> Single<DataSurvey> {
        guard let mock = listMock.first(where: { $0.case == .surveys }) else {
            return .error(APIError.somethingWentWrong)
        }
        
        switch mock {
        case .surveys(let result):
            switch result {
            case .success(let success):
                return .just(success)
            case .failure(let error):
                return .error(error)
            }
        }
    }
}
