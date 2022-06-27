//
//  HomeCoordinator.swift
//  Nimble-Code-Challenge
//
//  Created by Son Hoang on 27/06/2022.
//

import UIKit

final class HomeCoordinator: Coordinator {
    override func start() {
        let homeViewController = HomeViewController()
        navigationController.viewControllers = [homeViewController]
    }
}
