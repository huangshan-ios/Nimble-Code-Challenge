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
            .map({ result -> Bool in
                guard case .success = result else {
                    return false
                }
                return true
            })
            .toBlocking()
            .first()
        
        XCTAssertTrue(result!)
    }
    
    func testLoginFailed() throws {
        networkService.listMock = [.login(.failure(NetworkAPIError.notFound))]
        
        let result = try repository.login(with: "dev@nimblehq.co", and: "12345678")
            .map({ result -> Bool in
                guard
                    case let .failure(error) = result,
                    case .notFound = (error as? NetworkAPIError)
                else {
                    return false
                }
                return true
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
