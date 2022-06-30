//
//  LoginCoordinator.swift
//  Nimble-Code-Challenge
//
//  Created by Son Hoang on 24/06/2022.
//

import Foundation

final class LoginCoordinator: Coordinator {
    
    let isPresentation: Bool
    
    init(isPresentation: Bool = false) {
        self.isPresentation = isPresentation
    }
    
    override func start() {
        let networkService = NimbleNetworkServiceImpl()
        let repository = CredentialRepositoryImpl(networkService: networkService)
        let useCase = LoginViewUseCaseImpl(credentialRepository: repository)
        let viewModel = LoginViewModel(useCase: useCase)
        let loginViewController = LoginViewController(viewModel: viewModel, coordinator: self,
                                                      controller: LoginViewController.self)
        
        if isPresentation {
            navigationController.present(loginViewController, animated: true)
        } else {
            navigationController.viewControllers = [loginViewController]
        }
    }
    
    func navigateToHomeViewController() {
        if let appCoordinator = parentCoordinator as? AppCoordinator {
            let homeCoordinator = HomeCoordinator()
            homeCoordinator.navigationController = appCoordinator.navigationController
            appCoordinator.start(homeCoordinator)
            appCoordinator.finish(self)
        } else {
            if let loginViewController = navigationController.visibleViewController as? LoginViewController {
                loginViewController.dismiss(animated: true) { [weak self] in
                    guard let self = self else { return }
                    self.parentCoordinator?.finish(self)
                    NotificationCenter.default.post(name: .loginSuccess, object: nil)
                }
            }
        }
    }
    
}
