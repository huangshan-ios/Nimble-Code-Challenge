//
//  HomeViewModel.swift
//  Nimble-Code-Challenge
//
//  Created by Son Hoang on 30/06/2022.
//

import RxSwift
import RxCocoa

enum SwipeDirection {
    case backward
    case forward
}

final class HomeViewModel: ViewModelType {
    
    struct Input {
        let fetchSurveys: Observable<Void>
        let swipe: Observable<SwipeDirection>
    }
    
    struct Output {
        let isLoading: Signal<Bool>
        let error: Signal<Error?>
        let surveys: Driver<[Survey]>
        let currentIndex: Driver<Int>
    }
    
    let useCase: HomeViewUseCase
    
    init(useCase: HomeViewUseCase) {
        self.useCase = useCase
    }
    
    func transform(_ input: Input) -> Output {
        
        let activityIndicator = ActivityIndicator()
        let errorTrigger = PublishRelay<Error?>()
        
        var currentSurveyIndex: Int = 0
        var totalSurveys: Int = 0
        
        let fetchTrigger = input.fetchSurveys
            .flatMap { [weak self] _ -> Observable<[Survey]> in
                guard let self = self else { return .empty() }
                return self.useCase.fetchSurveys()
                    .trackActivity(activityIndicator)
                    .catch({ error in
                        errorTrigger.accept(error)
                        return .empty()
                    })
            }.do(onNext: { survey in
                totalSurveys = survey.count
            })
        
        let currentSurveyIndexTrigger = input.swipe
            .map { direction -> Int in
                switch direction {
                case .backward:
                    if currentSurveyIndex > 1 {
                        currentSurveyIndex -= 1
                    }
                case .forward:
                    if currentSurveyIndex < totalSurveys.count - 1 {
                        currentSurveyIndex += 1
                    }
                }
                return currentSurveyIndex
            }
        
        return Output(isLoading: activityIndicator.asSignal(onErrorJustReturn: false),
                      error: errorTrigger.asSignal(onErrorJustReturn: nil),
                      surveys: fetchTrigger.asDriver(onErrorJustReturn: []),
                      currentIndex: currentSurveyIndexTrigger.asDriver(onErrorJustReturn: 0))
    }
}
