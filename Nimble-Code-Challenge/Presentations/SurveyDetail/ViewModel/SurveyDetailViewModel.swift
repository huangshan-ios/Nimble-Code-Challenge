//
//  SurveyDetailViewModel.swift
//  Nimble-Code-Challenge
//
//  Created by Son Hoang on 01/07/2022.
//

import Foundation

final class SurveyDetailViewModel: ViewModelType {
    struct Input {}
    struct Output {}
    
    let useCase: SurveyDetailViewUseCase
    let survey: Survey
    
    init(useCase: SurveyDetailViewUseCase, survey: Survey) {
        self.useCase = useCase
        self.survey = survey
    }
    
    func transform(_ input: Input) -> Output {
        return Output()
    }
}
