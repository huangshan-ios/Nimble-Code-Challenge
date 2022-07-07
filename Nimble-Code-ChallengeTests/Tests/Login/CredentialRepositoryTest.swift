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
    
    // TODO: Write more test case
    
    override func setUp() {
        disposeBag = DisposeBag()
        networkService = NetworkServiceMock()
        repository = CredentialRepositoryImpl(networkService: networkService)
    }
    
    func testLoginSuccess() throws {
        networkService.listMock = [.success("login_success")]
        
        let result = try repository.login(with: "dev@nimblehq.co", and: "12345678")
            .toBlocking()
            .first()
        
        XCTAssertEqual(result!.accessToken, "lbxD2K2BjbYtNzz8xjvh2FvSKx838KBCf79q773kq2c")
    }
    
    func testLoginFailed() throws {
        networkService.listMock = [.failure(.json("login_incorect_password"))]
        
        let result = try repository.login(with: "dev@nimblehq.co", and: "12345678")
            .map({ _ in return true })
            .catch({ error in
                if error.toAPIError().code.elementsEqual("invalid_email_or_password") {
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
