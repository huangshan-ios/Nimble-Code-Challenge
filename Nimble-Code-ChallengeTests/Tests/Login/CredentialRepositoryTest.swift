//
//  CredentialRepositoryTest.swift
//  Nimble-Code-ChallengeTests
//
//  Created by Son Hoang on 29/06/2022.
//

import XCTest
import RxSwift
import RxBlocking

@testable import Nimble_Code_Challenge

class CredentialRepositoryTest: XCTestCase {
    
    private var disposeBag: DisposeBag!
    
    private var repository: CredentialRepositoryImpl!
    private var networkService: NetworkServiceMock!
    
    override func setUp() {
        disposeBag = DisposeBag()
        networkService = NetworkServiceMock()
        repository = CredentialRepositoryImpl(networkService: networkService)
    }
    
    func testLoginSuccess() throws {
        networkService.listMock = [.login(.success(.json("login_success")))]
        
        let result = try repository.login(with: "dev@nimblehq.co", and: "12345678")
            .toBlocking()
            .first()
        
        XCTAssertEqual(result!.id, "10")
    }
    
    func testLoginFailed() throws {
        networkService.listMock = [.login(.failure(APIErrorDTO.somethingWentWrong))]
        
        let result = try repository.login(with: "dev@nimblehq.co", and: "12345678")
            .map({ _ in return true })
            .catch({ error in
                let error = error.toAPIError()
                if !error.errors.isEmpty && error.errors.first!.code.elementsEqual("something_went_wrong") {
                    return .just(true)
                }
                return .just(false)
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
