//
//  LoginViewModel.swift
//  Nimble-Code-Challenge
//
//  Created by Son Hoang on 24/06/2022.
//

import RxSwift
import RxCocoa

class LoginViewModel: ViewModelType {
    
    struct Input {
        let email: Observable<String>
        let password: Observable<String>
        let login: Observable<Void>
        let forgotPassword: Observable<Void>
    }
    
    struct Output {
        let enableLoginButton: Driver<Bool>
        let isLoading: Signal<Bool>
        let error: Signal<AppError?>
        let loginSuccess: Signal<Void>
        let navigateToForgotPassword: Signal<Void>
    }
    
    let useCase: LoginViewUseCase
    
    init(useCase: LoginViewUseCase) {
        self.useCase = useCase
    }
    
    func transform(_ input: Input) -> Output {
        
        let activityIndicator = ActivityIndicator()
        let errorTrigger = PublishRelay<AppError?>()
        
        let credentials = Observable.combineLatest(input.email, input.password) {
            return (email: $0, password: $1)
        }
        
        let enableLoginButton = credentials.map { !$0.email.isEmpty && !$0.password.isEmpty }
        
        let loginStatus = input.login
            .withLatestFrom(credentials)
            .flatMap { [weak self] email, password -> Observable<Void> in
                guard let self = self else { return .empty() }
                return self.useCase
                    .login(with: email, and: password)
                    .trackActivity(activityIndicator)
                    .flatMap({ result -> Observable<Void> in
                        if case let .failure(error) = result {
                            errorTrigger.accept(error)
                            return .empty()
                        }
                        return .just(())
                    })
            }
        
        return Output(enableLoginButton: enableLoginButton.asDriver(onErrorJustReturn: false),
                      isLoading: activityIndicator.asSignal(onErrorJustReturn: false),
                      error: errorTrigger.asSignal(onErrorJustReturn: nil),
                      loginSuccess: loginStatus.asSignal(onErrorJustReturn: ()),
                      navigateToForgotPassword: input.forgotPassword.asSignal(onErrorJustReturn: ()))
    }
}
