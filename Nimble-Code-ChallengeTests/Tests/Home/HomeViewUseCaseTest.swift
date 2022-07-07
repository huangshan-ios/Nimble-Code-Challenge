//
//  HomeViewUseCaseTest.swift
//  Nimble-Code-ChallengeTests
//
//  Created by Son Hoang on 30/06/2022.
//

import XCTest
import RxSwift
import RxBlocking

@testable import Nimble_Code_Challenge

class HomeViewUseCaseTest: XCTestCase {
    
    private var disposeBag: DisposeBag!
    
    private var repository: SurveyRespositoryMock!
    private var useCase: HomeViewUseCase!
    
    // TODO: Write more test case

    override func setUp() {
        disposeBag = DisposeBag()
        
        repository = SurveyRespositoryMock(networkService: NetworkServiceMock())
        useCase = HomeViewUseCaseImpl(surveyRepository: repository)
    }
    
    func testFetchSurveysSuccess() throws {
        repository.listMock = [.surveys(.success("fetch_surveys_success"))]
        
        let result = try useCase.fetchSurveys(in: 0, with: 5)
            .toBlocking()
            .first()
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.data.count ?? 0, 2)
        XCTAssertEqual(result?.data[0].id, "d5de6a8f8f5f1cfe51bc")
    }
    
    func testFetchSurveysError() throws {
        repository.listMock = [.surveys(.failure(APIError.somethingWentWrong))]
        
        let result = try useCase.fetchSurveys(in: 0, with: 5)
            .catch({ error in
                if error.toAPIError().code.elementsEqual("something_went_wrong") {
                    return .just(DataSurvey(data: [], meta: nil))
                }
                return .never()
            })
            .toBlocking()
            .first()
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.data.count ?? 0, 0)
    }

    override func tearDown() {
        disposeBag = nil
        
        repository = nil
        useCase = nil
    }
}
