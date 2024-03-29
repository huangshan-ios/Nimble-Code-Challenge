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
        
        let splashCoordinator = SplashCoordinator()
        splashCoordinator.navigationController = navigationController
        start(splashCoordinator)
    }
}
