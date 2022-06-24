//
//  LoginCoordinator.swift
//  Nimble-Code-Challenge
//
//  Created by Son Hoang on 24/06/2022.
//

import Foundation

final class LoginCoordinator: Coordinator {
    
    override func start() {
        let loginViewController = LoginViewController(viewModel: LoginViewModel(),
                                                      coordinator: self,
                                                      controller: LoginViewController.self)
        
        navigationController.viewControllers = [loginViewController]
    }
    
}
