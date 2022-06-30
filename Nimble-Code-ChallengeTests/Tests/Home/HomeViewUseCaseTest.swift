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
        repository.listMock = [.surveys(.success(.json("fetch_surveys_success")))]
        
        let result = try useCase.fetchSurveys()
            .toBlocking()
            .first()
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.count ?? 0, 2)
        XCTAssertEqual(result?[0].id, "d5de6a8f8f5f1cfe51bc")
    }
    
    func testFetchSurveysError() throws {
        repository.listMock = [.surveys(.failure(APIErrorDTO.somethingWentWrong))]
        
        let result = try useCase.fetchSurveys()
            .catch({ error in
                let error = error.toAPIError()
                if !error.errors.isEmpty && error.errors.first!.detail.elementsEqual("Something went wrong") {
                    return .just([])
                }
                return .never()
            })
            .toBlocking()
            .first()
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.count ?? 0, 0)
    }

    override func tearDown() {
        disposeBag = nil
        
        repository = nil
        useCase = nil
    }
}
