//
//  LoginCoordinator.swift
//  Nimble-Code-Challenge
//
//  Created by Son Hoang on 24/06/2022.
//

import Foundation

final class LoginCoordinator: Coordinator {
    
    override func start() {
        let repository = CredentialRepositoryImpl()
        let useCase = LoginViewUseCaseImpl(credentialRepository: repository)
        let viewModel = LoginViewModel(useCase: useCase)
        let loginViewController = LoginViewController(viewModel: viewModel, coordinator: self,
                                                      controller: LoginViewController.self)
        
        navigationController.viewControllers = [loginViewController]
    }
    
}
