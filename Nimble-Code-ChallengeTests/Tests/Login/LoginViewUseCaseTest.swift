//
//  LoginViewUseCaseTest.swift
//  Nimble-Code-ChallengeTests
//
//  Created by Son Hoang on 28/06/2022.
//

import XCTest
import RxSwift
import RxBlocking

@testable import Nimble_Code_Challenge

class LoginViewUseCaseTest: XCTestCase {
    
    private var disposeBag: DisposeBag!
    
    private var repository: CredentialRepositoryMock!
    private var useCase: LoginViewUseCaseImpl!
    
    // TODO: Write more test case
    
    override func setUp() {
        disposeBag = DisposeBag()
        repository = CredentialRepositoryMock(networkService: NetworkServiceMock())
        useCase = LoginViewUseCaseImpl(credentialRepository: repository)
    }
    
    func testLoginSuccess() throws {
        repository.listMock = [.login(.success(.json("login_success")))]
        
        let result = try useCase.login(with: "dev@nimblehq.co", and: "12345678")
            .toBlocking()
            .first()
        
        XCTAssertTrue(result!)
    }
    
    func testLoginError() throws {
        repository.listMock = [.login(.failure(APIErrorDTO.somethingWentWrong))]
        
        let result = try useCase.login(with: "dev@nimblehq.co", and: "12345678")
            .catch({ error in
                let error = error.toAPIError()
                if !error.errors.isEmpty && error.errors.first!.detail.elementsEqual("Something went wrong") {
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
        repository = nil
        useCase = nil
    }

}
