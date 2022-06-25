//
//  LoginViewModel.swift
//  Nimble-Code-Challenge
//
//  Created by Son Hoang on 24/06/2022.
//

import RxSwift

class LoginViewModel: ViewModelType {
    
    struct Input {
        let email: Observable<String>
        let password: Observable<String>
        let login: Observable<Void>
        let forgotPassword: Observable<Void>
    }
    
    struct Output {
        let enableLoginButton: Observable<Bool>
        let isLoading: Observable<Bool>
        let loginSuccess: Observable<Void>
    }
    
    private let disposeBag = DisposeBag()
    
    let useCase: LoginViewUseCase
    
    init(useCase: LoginViewUseCase) {
        self.useCase = useCase
    }
    
    func transform(_ input: Input) -> Output {
        return Output(enableLoginButton: .just(false),
                      isLoading: .just(false),
                      loginSuccess: .just(()))
    }
}
