//
//  LoginViewModelTest.swift
//  Nimble-Code-ChallengeTests
//
//  Created by Son Hoang on 27/06/2022.
//

import XCTest
import RxSwift
import RxTest
import RxBlocking

@testable import Nimble_Code_Challenge

class LoginViewModelTest: XCTestCase {
    
    private var disposeBag: DisposeBag!
    
    private var viewModel: LoginViewModel!
    private var useCase: LoginViewUseCaseMock!
    
    private var output: LoginViewModel.Output!
    
    private let emailTriggerSubject = PublishSubject<String>()
    private let passwordTriggerSubject = PublishSubject<String>()
    private let loginButtonTriggerSubject = PublishSubject<Void>()
    
    private var scheduler: TestScheduler!
    
    override func setUp() {
        
        disposeBag = DisposeBag()
        useCase = LoginViewUseCaseMock(credentialRepository: CredentialRepositoryImpl(networkService: NetworkServiceImpl()))
        viewModel = LoginViewModel(useCase: useCase)
        
        let input = LoginViewModel.Input(email: emailTriggerSubject.asObservable(),
                                         password: passwordTriggerSubject.asObservable(),
                                         login: loginButtonTriggerSubject.asObservable(),
                                         forgotPassword: .empty())
        
        output = viewModel.transform(input)
        
        output.enableLoginButton
            .drive()
            .disposed(by: disposeBag)
    }
    
    func testLoginButtonEnabled() throws {
        emailTriggerSubject.onNext("dev@nimblehq.co")
        passwordTriggerSubject.onNext("12345678")
        
        let enableLoginButton = try output.enableLoginButton.toBlocking().first()
        
        XCTAssertTrue(enableLoginButton!)
    }
    
    func testLoginButtonIsNotEnabledWhenInputOnlyEmail() throws {
        emailTriggerSubject.onNext("dev@nimblehq.co")
        passwordTriggerSubject.onNext("")
        
        let enableLoginButton = try output.enableLoginButton.toBlocking().first()
        
        XCTAssertFalse(enableLoginButton!)
    }
    
    func testLoginButtonIsNotEnabledWhenInputOnlyPassword() throws {
        emailTriggerSubject.onNext("")
        passwordTriggerSubject.onNext("12345678")
        
        let enableLoginButton = try output.enableLoginButton.toBlocking().first()
        
        XCTAssertFalse(enableLoginButton!)
    }
    
    func testLoginButtonIsNotEnabledWhenInputNothing() throws {
        emailTriggerSubject.onNext("")
        passwordTriggerSubject.onNext("")
        
        let enableLoginButton = try output.enableLoginButton.toBlocking().first()
        
        XCTAssertFalse(enableLoginButton!)
    }
    
    func testLoginSuccess() throws {
        scheduler = TestScheduler(initialClock: 0)

        let isLoginSuccess = scheduler.createObserver(Bool.self)
        
        useCase.listMock = [.login(.success(()))]
        
        output.loginSuccess
            .map({ _ in return true })
            .emit(to: isLoginSuccess)
            .disposed(by: disposeBag)
        
        scheduler.createHotObservable([.next(0, "dev@nimblehq.co")])
            .bind(to: emailTriggerSubject)
            .disposed(by: disposeBag)
        
        scheduler.createHotObservable([.next(0, "12345678")])
            .bind(to: passwordTriggerSubject)
            .disposed(by: disposeBag)
        
        scheduler.createHotObservable([.next(10, ())])
            .bind(to: loginButtonTriggerSubject)
            .disposed(by: disposeBag)
        
        scheduler.start()
  
        XCTAssertEqual(isLoginSuccess.events, [.next(10, true)])
    }
    
    override func tearDown() {
        viewModel = nil
        useCase = nil
        output = nil
        
        scheduler = nil
        
        disposeBag = nil
    }
    
}
