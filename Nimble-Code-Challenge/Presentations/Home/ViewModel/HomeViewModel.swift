//
//  HomeViewModel.swift
//  Nimble-Code-Challenge
//
//  Created by Son Hoang on 30/06/2022.
//

import Foundation

final class HomeViewModel: ViewModelType {
    struct Input {}
    struct Output {}
    
    let useCase: HomeViewUseCase
    
    init(useCase: HomeViewUseCase) {
        self.useCase = useCase
    }
    
    func transform(_ input: Input) -> Output {
        return Output()
    }
}
