//
//  AppCoordinator.swift
//  Nimble-Code-Challenge
//
//  Created by Son Hoang on 24/06/2022.
//

import UIKit

final class AppCoordinator: Coordinator {
    var window: UIWindow?
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    override func start() {
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        let loginCoordinator = LoginCoordinator()
        loginCoordinator.navigationController = navigationController
        start(loginCoordinator)
    }
    
    func changeRootToHomeView() {
        let homeViewCoordinator = HomeCoordinator()
        homeViewCoordinator.navigationController = navigationController
        start(homeViewCoordinator)
    }
}
