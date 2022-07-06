//
//  HomeViewModel.swift
//  Nimble-Code-Challenge
//
//  Created by Son Hoang on 30/06/2022.
//

import RxSwift
import RxCocoa

enum SurveyFetchType {
    case reload
    case loadMore
}

final class HomeViewModel: ViewModelType {
    
    struct Input {
        let fetchSurveys: Observable<SurveyFetchType>
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
        
        let numberItemPerPage: Int = 5
        var currentRequestPage: Int = 0
        var maxPage: Int?
        
        let reloadSurveys = NotificationCenter.default.rx
            .notification(.loginSuccess, object: nil)
            .map({ _ -> SurveyFetchType in
                return .reload
            })
        
        let fetchTrigger = Observable.merge(input.fetchSurveys, reloadSurveys)
            .withLatestFrom(activityIndicator) { (fetchType: $0, isLoading: $1) }
            .flatMap { [weak self] input -> Observable<[Survey]> in
                guard
                    !input.isLoading,
                    let self = self,
                    let pageCalculated = self.calculatePage(with: currentRequestPage,
                                                              maxPage: maxPage,
                                                              fetchType: input.fetchType)
                else {
                    return .empty()
                }
                
                maxPage = pageCalculated.maxPage
                currentRequestPage = pageCalculated.requestPage
                
                return self.fetchSurveys(in: currentRequestPage, with: numberItemPerPage,
                                         errorTrigger: errorTrigger,
                                         activityIndicator: activityIndicator)
                .map { [weak self] dataSurvey in
                    guard let self = self else {
                        return totalSurveys
                    }
                    
                    maxPage = dataSurvey.meta?.pages
                    let surveys = self.calculateSurveys(currentSurveys: totalSurveys,
                                                        loadedSurveys: dataSurvey.data,
                                                        surveyTrigger: surveyTrigger,
                                                        fetchType: input.fetchType)
                    totalSurveys = surveys
                    return surveys
                }
            }
        
        let swipeToIndexTrigger = input.swipeToIndex
            .distinctUntilChanged()
            .compactMap({ index -> (survey: Survey?, index: Int)? in
                guard let survey = totalSurveys[safe: index] else {
                    return nil
                }
                return (survey: survey, index: index)
            })
        
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

extension HomeViewModel {
    private func calculatePage(
        with page: Int,
        maxPage: Int?,
        fetchType: SurveyFetchType
    ) -> (requestPage: Int, maxPage: Int?)? {
        switch fetchType {
        case .reload:
            return (requestPage: 0, maxPage: nil)
        case .loadMore:
            if let maxPage = maxPage, page < maxPage {
                return (requestPage: page + 1, maxPage: nil)
            } else {
                return nil
            }
        }
    }
    
    private func calculateSurveys(
        currentSurveys: [Survey],
        loadedSurveys: [Survey],
        surveyTrigger: PublishSubject<(survey: Survey?, index: Int)>,
        fetchType: SurveyFetchType
    ) -> [Survey] {
        var surveys = currentSurveys
        
        switch fetchType {
        case .reload:
            surveys = loadedSurveys
            if let survey = surveys[safe: 0] {
                surveyTrigger.onNext((survey: survey,
                                      index: 0))
            }
        case .loadMore:
            surveys.append(contentsOf: loadedSurveys)
        }
        
        return surveys
    }
    
    private func fetchSurveys(
        in page: Int, with size: Int,
        errorTrigger: PublishRelay<Error?>,
        activityIndicator: ActivityIndicator
    ) -> Observable<DataSurvey> {
        return useCase.fetchSurveys(in: page, with: size)
            .trackActivity(activityIndicator)
            .catch({ error in
                errorTrigger.accept(error)
                return .empty()
            })
    }
}
