//
//  HomeCoordinator.swift
//  Nimble-Code-Challenge
//
//  Created by Son Hoang on 27/06/2022.
//

import UIKit

final class HomeCoordinator: Coordinator {
    override func start() {
        let viewModel = HomeViewModel()
        let homeViewController = HomeViewController(viewModel: viewModel,
                                                    coordinator: self,
                                                    controller: HomeViewController.self)
        navigationController.viewControllers = [homeViewController]
    }
}
