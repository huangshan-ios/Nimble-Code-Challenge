//
//  SurveyDetailCoordinator.swift
//  Nimble-Code-Challenge
//
//  Created by Son Hoang on 01/07/2022.
//

import Foundation
import UIKit

final class SurveyDetailCoordinator: Coordinator {
    
    let survey: Survey
    
    init(survey: Survey) {
        self.survey = survey
    }
    
    override func start() {
        let nimbleNetworkService = NimbleNetworkServiceImpl()
        let repository = SurveyRepositoryImpl(networkService: nimbleNetworkService)
        let usecase = SurveyDetailViewUseCaseImpl(surveyRepository: repository)
        let viewModel = SurveyDetailViewModel(useCase: usecase, survey: survey)
        let surveyDetailViewController = SurveyDetailViewController(viewModel: viewModel,
                                                                    coordinator: self,
                                                                    controller: SurveyDetailViewController.self)
        
        navigationController.pushViewController(surveyDetailViewController, animated: false)
    }
}
