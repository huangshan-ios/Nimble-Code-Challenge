//
//  SplashCoordinator.swift
//  Nimble-Code-Challenge
//
//  Created by Son Hoang on 07/07/2022.
//

import Foundation

final class SplashCoordinator: Coordinator {
    override func start() {
        let splashViewController = SplashViewController(viewModel: SplashViewModel(),
                                                        coordinator: self,
                                                        controller: SplashViewController.self)
        navigationController.viewControllers = [splashViewController]
    }
    
    func startApp() {
        if UserSession.shared.isLoggedIn {
            setRootToHome()
        } else {
            setRootToLogin()
        }
    }
    
    private func setRootToLogin() {
        let loginCoordinator = LoginCoordinator()
        loginCoordinator.navigationController = navigationController
        start(loginCoordinator)
    }
    
    private func setRootToHome() {
        let homeViewCoordinator = HomeCoordinator()
        homeViewCoordinator.navigationController = navigationController
        start(homeViewCoordinator)
    }
}
