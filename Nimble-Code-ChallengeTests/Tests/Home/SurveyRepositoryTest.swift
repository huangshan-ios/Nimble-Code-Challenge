//
//  SurveyRepositoryTest.swift
//  Nimble-Code-ChallengeTests
//
//  Created by Son Hoang on 30/06/2022.
//

import XCTest
import RxSwift
import RxBlocking

@testable import Nimble_Code_Challenge

class SurveyRepositoryTest: XCTestCase {
    
    private var disposeBag: DisposeBag!
    
    private var repository: SurveyRepositoryImpl!
    private var networkService: NetworkServiceMock!
    
    // TODO: Write more test case
    
    override func setUp() {
        disposeBag = DisposeBag()
        networkService = NetworkServiceMock()
        repository = SurveyRepositoryImpl(networkService: networkService)
    }
    
    func testFetchSurveysSuccess() throws {
        networkService.listMock = [.success("fetch_surveys_success")]
        
        let result = try repository.fetchSurveys(in: 0, with: 5)
            .toBlocking()
            .first()
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.0.count ?? 0, 2)
        XCTAssertEqual(result?.0[0].id, "d5de6a8f8f5f1cfe51bc")
    }
    
    func testFetchSurveysFailed() throws {
        networkService.listMock = [.failure(.json("fetch_surveys_success_invalid_page_number"))]
        
        let result = try repository.fetchSurveys(in: 0, with: 5)
            .map({ _ in return true })
            .catch({ error in
                return .just(true)
            })
            .toBlocking()
            .first()
        
        XCTAssertTrue(result!)
    }

    override func tearDown() {
        disposeBag = nil
        networkService = nil
        repository = nil
    }
}
