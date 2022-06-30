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
    
    // TODO: Write more test case
    
    override func setUp() {
        
        disposeBag = DisposeBag()
        useCase = LoginViewUseCaseMock(credentialRepository: CredentialRepositoryMock(networkService: NetworkServiceMock()))
        viewModel = LoginViewModel(useCase: useCase)
        scheduler = TestScheduler(initialClock: 0)
        
        let input = LoginViewModel.Input(email: emailTriggerSubject.asObservable(),
                                         password: passwordTriggerSubject.asObservable(),
                                         login: loginButtonTriggerSubject.asObservable(),
                                         forgotPassword: .empty())
        
        output = viewModel.transform(input)
    }
    
    private func prepareForTestLoginButton() {
        output.enableLoginButton
            .drive()
            .disposed(by: disposeBag)
    }
    
    private func prepareForTestLogin() {
        output.loginSuccess
            .emit()
            .disposed(by: disposeBag)
    }
    
    func testLoginButtonEnabled() throws {
        prepareForTestLoginButton()
        
        emailTriggerSubject.onNext("dev@nimblehq.co")
        passwordTriggerSubject.onNext("12345678")
        
        let enableLoginButton = try output.enableLoginButton.toBlocking().first()
        
        XCTAssertTrue(enableLoginButton!)
    }
    
    func testLoginButtonIsNotEnabledWhenInputOnlyEmail() throws {
        prepareForTestLoginButton()
        
        emailTriggerSubject.onNext("dev@nimblehq.co")
        passwordTriggerSubject.onNext("")
        
        let enableLoginButton = try output.enableLoginButton.toBlocking().first()
        
        XCTAssertFalse(enableLoginButton!)
    }
    
    func testLoginButtonIsNotEnabledWhenInputOnlyPassword() throws {
        prepareForTestLoginButton()
        
        emailTriggerSubject.onNext("")
        passwordTriggerSubject.onNext("12345678")
        
        let enableLoginButton = try output.enableLoginButton.toBlocking().first()
        
        XCTAssertFalse(enableLoginButton!)
    }
    
    func testLoginButtonIsNotEnabledWhenInputNothing() throws {
        prepareForTestLoginButton()
        
        emailTriggerSubject.onNext("")
        passwordTriggerSubject.onNext("")
        
        let enableLoginButton = try output.enableLoginButton.toBlocking().first()
        
        XCTAssertFalse(enableLoginButton!)
    }
    
    func testLoginSuccess() throws {
        let isLoginSuccess = scheduler.createObserver(Bool.self)
        
        useCase.listMock = [.login(.success(true))]
        
        output.loginSuccess
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
    
    func testLoginError() throws {
        prepareForTestLogin()
        
        let isLoginError = scheduler.createObserver(Bool.self)
        
        useCase.listMock = [.login(.failure(APIErrorDTO.somethingWentWrong))]
        
        output.error
            .map({ error in
                return !(error?.toAPIError().errors.isEmpty ?? false)
            })
            .emit(to: isLoginError)
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
        
        XCTAssertEqual(isLoginError.events, [.next(10, true)])
    }
    
    func testLoadingStates() throws {
        prepareForTestLogin()
        
        let loadingStates = scheduler.createObserver(Bool.self)
        
        useCase.listMock = [.login(.success(true))]
        
        output.isLoading
            .emit(to: loadingStates)
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
        
        XCTAssertEqual(loadingStates.events, [.next(0, false),
                                              .next(10, true),
                                              .next(10, false)])
    }
    
    override func tearDown() {
        disposeBag = nil
        
        viewModel = nil
        useCase = nil
        output = nil
        
        scheduler = nil
    }
    
}
