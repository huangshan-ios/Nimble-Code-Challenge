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
    
    private lazy var mockDTO: CredentialDTO = {
        return CredentialDTO(id: "1",
                        type: "Bearer",
                        attributes: CredentialAttributesDTO(access_token: "lbxD2K2BjbYtNzz8xjvh2FvSKx838KBCf79q773kq2c",
                                                       token_type: "Bearer", expires_in: 7200,
                                                       refresh_token: "3zJz2oW0njxlj_I3ghyUBF7ZfdQKYXd2n0ODlMkAjHc", created_at: 1597169495))
    }()
    
    override func setUp() {
        disposeBag = DisposeBag()
        repository = CredentialRepositoryMock(networkService: NetworkServiceImpl())
        useCase = LoginViewUseCaseImpl(credentialRepository: repository)
    }
    
    func testLoginSuccess() throws {
        repository.listMock = [.login(.success(mockDTO))]
        
        let result = try useCase.login(with: "dev@nimblehq.co", and: "12345678")
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
    
    func testLoginError() throws {
        repository.listMock = [.login(.failure(NetworkAPIError.notFound))]
        
        let result = try useCase.login(with: "dev@nimblehq.co", and: "12345678")
            .map({ result -> Bool in
                guard
                    case let .failure(error) = result,
                    case .somethingWentWrong = error
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
        repository = nil
        useCase = nil
    }

}
