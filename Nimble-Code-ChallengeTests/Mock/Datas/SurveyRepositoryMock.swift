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
        case surveys(Result<DataTypeMock, Error>)
        
        enum Case {
            case surveys
        }
        
        var `case`: Case {
            switch self {
            case .surveys: return .surveys
            }
        }
    }
    
    func fetchSurveys() -> Single<DataResponseDTO<[SurveyDTO]>> {
        guard let mock = listMock.first(where: { $0.case == .surveys }) else {
            return .error(APIErrorDTO.somethingWentWrong)
        }
        
        switch mock {
        case .surveys(let result):
            switch result {
            case .success(let dataType):
                switch dataType {
                case .json(let fileName):
                    let object = loadJSON(filename: fileName, type: DataResponseDTO<[SurveyDTO]>.self)
                    return .just(object)
                case .object(let object):
                    guard let object = object as? DataResponseDTO<[SurveyDTO]> else {
                        return .error(APIErrorDTO.somethingWentWrong)
                    }
                    return .just(object)
                }
            case .failure(let error):
                return .error(error)
            }
        }
    }
}
