//
//  HomeCoordinator.swift
//  Nimble-Code-Challenge
//
//  Created by Son Hoang on 27/06/2022.
//

import UIKit

final class HomeCoordinator: Coordinator {
    override func start() {
        let networkService = NimbleNetworkServiceImpl()
        let repository = SurveyRepositoryImpl(networkService: networkService)
        let useCase = HomeViewUseCaseImpl(surveyRepository: repository)
        let viewModel = HomeViewModel(useCase: useCase)
        let homeViewController = HomeViewController(viewModel: viewModel,
                                                    coordinator: self,
                                                    controller: HomeViewController.self)
        navigationController.viewControllers = [homeViewController]
    }
    
    func logout() {
        guard let appCoordinator = parentCoordinator as? AppCoordinator else {
            return
        }
        let loginCoordinator = LoginCoordinator()
        loginCoordinator.navigationController = navigationController
        appCoordinator.start(loginCoordinator)
        appCoordinator.finish(self)
    }
    
    func gotoSurveyDetail(survey: Survey) {
        // TODO: Animate to go to survey detail
    }
}
