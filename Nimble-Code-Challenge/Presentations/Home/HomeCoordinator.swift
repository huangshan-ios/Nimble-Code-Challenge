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
    
    func gotoSurveyDetail(survey: Survey) {
        // TODO: Animate to go to survey detail
    }
}
