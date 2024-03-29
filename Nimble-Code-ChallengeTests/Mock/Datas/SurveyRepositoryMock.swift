//
//  SurveyRepositoryMock.swift
//  Nimble-Code-ChallengeTests
//
//  Created by Son Hoang on 01/07/2022.
//

import RxSwift

@testable import Nimble_Code_Challenge

final class SurveyRespositoryMock: SurveyRepository, Mockable {
    
    let networkService: NimbleNetworkService
    
    init(networkService: NimbleNetworkService) {
        self.networkService = networkService
    }
    
    var listMock: [MockType] = []
    
    enum MockType {
        case surveys(Result<String, Error>)
        case surveyDetail(Result<DataTypeMock, Error>)
        
        enum Case {
            case surveys
            case surveyDetail
        }
        
        var `case`: Case {
            switch self {
            case .surveys: return .surveys
            case .surveyDetail: return .surveyDetail
            }
        }
    }
    
    func fetchSurveys(in page: Int, with size: Int) -> Single<([SurveyDTO], MetaDTO)> {
        guard let mock = listMock.first(where: { $0.case == .surveys }),
              case let .surveys(result) = mock
        else {
            return .error(APIError.somethingWentWrong)
        }
        
        switch result {
        case .success(let fileName):
            let object = loadJSON(filename: fileName, type: [SurveyDTO].self, metaType: MetaDTO.self)
            return .just(object)
        case .failure(let error):
            return .error(error)
        }
    }
    
    func getDetailSurvey(_ surveyId: String) -> Single<DataSurveyDetailDTO> {
        guard let mock = listMock.first(where: { $0.case == .surveyDetail }),
              case let .surveyDetail(result) = mock
        else {
            return .error(APIError.somethingWentWrong)
        }
        
        switch result {
        case .success(let dataType):
            switch dataType {
            case .json(let fileName):
                let object = loadJSON(filename: fileName, type: DataSurveyDetailDTO.self)
                return .just(object)
            case .object(let object):
                guard let object = object as? DataSurveyDetailDTO else {
                    return .error(APIError.somethingWentWrong)
                }
                return .just(object)
            }
        case .failure(let error):
            return .error(error)
        }
    }
}
