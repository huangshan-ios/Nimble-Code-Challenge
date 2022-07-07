//
//  LoginCoordinator.swift
//  Nimble-Code-Challenge
//
//  Created by Son Hoang on 24/06/2022.
//

import UIKit

final class LoginCoordinator: Coordinator {
    
    let isPresentation: Bool
    let customNavigationDelegate = LoginTransitionManager(duration: 0.8)
    
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
            // Remove the delegate for the transition animation first
            // Cause maybe the delegate of the animation still exist
            navigationController.delegate = nil
            navigationController.present(loginViewController, animated: true)
        } else {
            navigationController.delegate = customNavigationDelegate
            navigationController.setViewControllers([loginViewController], animated: true)
        }
    }
    
    func navigateToHomeViewController() {
        // Remove the delegate for the transition animation first
        // Cause maybe the delegate of the animation still exist
        navigationController.delegate = nil
        
        if let splashCoordinator = parentCoordinator as? SplashCoordinator,
           let appCoordinator = splashCoordinator.parentCoordinator as? AppCoordinator {
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
