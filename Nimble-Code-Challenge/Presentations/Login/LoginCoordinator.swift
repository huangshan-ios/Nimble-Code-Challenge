//
//  LoginCoordinator.swift
//  Nimble-Code-Challenge
//
//  Created by Son Hoang on 24/06/2022.
//

import Foundation

final class LoginCoordinator: Coordinator {
    
    override func start() {
        let networkService = NetworkServiceImpl()
        let repository = CredentialRepositoryImpl(networkService: networkService)
        let useCase = LoginViewUseCaseImpl(credentialRepository: repository)
        let viewModel = LoginViewModel(useCase: useCase)
        let loginViewController = LoginViewController(viewModel: viewModel, coordinator: self,
                                                      controller: LoginViewController.self)
        
        navigationController.viewControllers = [loginViewController]
    }
    
    func navigateToHomeViewController() {
        guard let appCoordinator = parentCoordinator as? AppCoordinator else {
            return
        }
        let homeCoordinator = HomeCoordinator()
        homeCoordinator.navigationController = appCoordinator.navigationController
        appCoordinator.start(homeCoordinator)
        appCoordinator.finish(self)
    }
    
}
