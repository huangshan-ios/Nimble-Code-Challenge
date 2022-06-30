//
//  HomeViewModel.swift
//  Nimble-Code-Challenge
//
//  Created by Son Hoang on 30/06/2022.
//

import RxSwift
import RxCocoa

final class HomeViewModel: ViewModelType {
    
    struct Input {
        let fetchSurveys: Observable<Void>
        let swipeToIndex: Observable<Int>
    }
    
    struct Output {
        let isLoading: Signal<Bool>
        let error: Signal<Error?>
        let surveys: Driver<[Survey]>
        let currentSurvey: Driver<(survey: Survey?, index: Int)>
    }
    
    let useCase: HomeViewUseCase
    
    init(useCase: HomeViewUseCase) {
        self.useCase = useCase
    }
    
    func transform(_ input: Input) -> Output {
        
        let activityIndicator = ActivityIndicator()
        let errorTrigger = PublishRelay<Error?>()
        let surveyTrigger = PublishSubject<(survey: Survey?, index: Int)>()
        
        var totalSurveys: [Survey] = []
        
        let reloadSurveys = NotificationCenter.default.rx
            .notification(.reloadHomeScreen, object: nil)
            .map { _ in }
        
        let fetchTrigger = Observable.merge(input.fetchSurveys, reloadSurveys)
            .withLatestFrom(activityIndicator)
            .flatMap { [weak self] isLoading -> Observable<[Survey]> in
                guard let self = self, !isLoading else { return .empty() }
                return self.useCase.fetchSurveys()
                    .trackActivity(activityIndicator)
                    .catch({ error in
                        errorTrigger.accept(error)
                        return .empty()
                    })
            }.do(onNext: { surveys in
                totalSurveys = surveys
                if let survey = surveys[safe: 0] {
                    surveyTrigger.onNext((survey: survey,
                                          index: 0))
                }
            })
        
        let swipeToIndexTrigger = input.swipeToIndex
                .compactMap { index -> (survey: Survey?, index: Int)? in
                    guard let survey = totalSurveys[safe: index] else {
                        return nil
                    }
                    return (survey: survey, index: index)
                }
        
        let currentSurveyTrigger = Observable.merge(swipeToIndexTrigger,
                                                    surveyTrigger.asObserver())
        
        return Output(
            isLoading: activityIndicator.asSignal(onErrorJustReturn: false),
            error: errorTrigger.asSignal(onErrorJustReturn: nil),
            surveys: fetchTrigger.asDriver(onErrorJustReturn: []),
            currentSurvey: currentSurveyTrigger
                .asDriver(onErrorJustReturn: (survey: nil, index: 0))
        )
    }
}
