//
//  HomeViewModelTest.swift
//  Nimble-Code-ChallengeTests
//
//  Created by Son Hoang on 30/06/2022.
//

import XCTest
import RxSwift
import RxTest
import RxBlocking

@testable import Nimble_Code_Challenge

class HomeViewModelTest: XCTestCase {
    
    private var disposeBag: DisposeBag!
    
    private var viewModel: HomeViewModel!
    private var useCase: HomeViewUseCaseMock!
    
    private var output: HomeViewModel.Output!
    
    private let fetchSurveysTrigger = PublishSubject<SurveyFetchType>()
    private let swipeToIndexTrigger = PublishSubject<Int>()
    
    private var scheduler: TestScheduler!
    
    // TODO: Write more test case
    
    override func setUp() {
        disposeBag = DisposeBag()
        
        useCase = HomeViewUseCaseMock(surveyRepository: SurveyRepositoryImpl(networkService: NimbleNetworkServiceImpl()))
        viewModel = HomeViewModel(useCase: useCase)
        
        scheduler = TestScheduler(initialClock: 0)
        
        let input = HomeViewModel.Input(fetchSurveys: fetchSurveysTrigger.asObservable(),
                                        swipeToIndex: swipeToIndexTrigger.asObservable())
        output = viewModel.transform(input)
    }
    
    func testFetchSurveysSuccess() {
        let surveysObserver = scheduler.createObserver([Survey].self)
        let currentSurveyObserver = scheduler.createObserver((survey: Survey?, index: Int).self)
        let meta = DataSurvey.Meta(page: 0, pages: 5, pageSize: 5, records: 20)
        let dataSurvey = DataSurvey(data: surveys, meta: meta)
        
        useCase.listMock = [.surveys(.success(dataSurvey))]
        
        output.surveys
            .drive(surveysObserver)
            .disposed(by: disposeBag)
        
        output.currentSurvey
            .drive(currentSurveyObserver)
            .disposed(by: disposeBag)
        
        scheduler.createHotObservable([.next(0, .reload)])
            .bind(to: fetchSurveysTrigger)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        let surveysCountEvent = surveysObserver.events
            .compactMap({ event -> Int? in
                return event.value.element?.count
            })
        
        let currentSurveyEvent = currentSurveyObserver.events
            .compactMap({ event -> Survey? in
                return event.value.element?.survey
            })
        
        XCTAssertEqual(currentSurveyEvent.first!.id, surveys[0].id)
        XCTAssertEqual(surveysCountEvent, [5])
    }
    
    func testLoadMoreSurveysSuccess() {
        let surveysObserver = scheduler.createObserver([Survey].self)
        let currentSurveyObserver = scheduler.createObserver((survey: Survey?, index: Int).self)
        let meta = DataSurvey.Meta(page: 0, pages: 5, pageSize: 5, records: 20)
        let dataSurvey = DataSurvey(data: surveys, meta: meta)
        
        useCase.listMock = [.surveys(.success(dataSurvey))]
        
        output.surveys
            .drive(surveysObserver)
            .disposed(by: disposeBag)
        
        output.currentSurvey
            .drive(currentSurveyObserver)
            .disposed(by: disposeBag)
        
        scheduler.createHotObservable([.next(0, .reload),
                                       .next(10, .loadMore)])
            .bind(to: fetchSurveysTrigger)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        let surveysCountEvent = surveysObserver.events
            .compactMap({ event -> Int? in
                return event.value.element?.count
            })
        
        let currentSurveyEvent = currentSurveyObserver.events
            .compactMap({ event -> Survey? in
                return event.value.element?.survey
            })
        
        XCTAssertEqual(currentSurveyEvent.first!.id, surveys[0].id)
        XCTAssertEqual(surveysCountEvent, [5, 10])
    }
    
    func testFetchSurveysError() {
        let isFetchSurveysErrorObserver = scheduler.createObserver(Bool.self)
        
        useCase.listMock = [.surveys(.failure(APIErrorDTO.somethingWentWrong))]
        
        output.surveys
            .drive()
            .disposed(by: disposeBag)
        
        output.error
            .map({ error in
                return !(error?.toAPIError().errors!.isEmpty ?? false)
            })
            .emit(to: isFetchSurveysErrorObserver)
            .disposed(by: disposeBag)
        
        scheduler.createHotObservable([.next(0, .reload)])
            .bind(to: fetchSurveysTrigger)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        XCTAssertEqual(isFetchSurveysErrorObserver.events, [.next(0, true)])
    }
    
    func testLoadingStates() throws {
        let loadingStatesObserver = scheduler.createObserver(Bool.self)
        let meta = DataSurvey.Meta(page: 0, pages: 5, pageSize: 5, records: 20)
        let dataSurvey = DataSurvey(data: surveys, meta: meta)
        
        useCase.listMock = [.surveys(.success(dataSurvey))]
        
        output.surveys
            .drive()
            .disposed(by: disposeBag)
        
        output.isLoading
            .emit(to: loadingStatesObserver)
            .disposed(by: disposeBag)
        
        scheduler.createHotObservable([.next(0, .reload)])
            .bind(to: fetchSurveysTrigger)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        XCTAssertEqual(loadingStatesObserver.events, [.next(0, false),
                                                      .next(0, true),
                                                      .next(0, false)])
    }
    
    func testSwipeToNextIndex() throws {
        let currentSurveyObserver = scheduler.createObserver((survey: Survey?, index: Int).self)
        let meta = DataSurvey.Meta(page: 0, pages: 5, pageSize: 5, records: 20)
        let dataSurvey = DataSurvey(data: surveys, meta: meta)
        
        useCase.listMock = [.surveys(.success(dataSurvey))]
        
        output.surveys
            .drive()
            .disposed(by: disposeBag)
        
        output.currentSurvey
            .drive(currentSurveyObserver)
            .disposed(by: disposeBag)
        
        scheduler.createHotObservable([.next(0, .reload)])
            .bind(to: fetchSurveysTrigger)
            .disposed(by: disposeBag)
        
        scheduler.createHotObservable([.next(10, 1)])
            .bind(to: swipeToIndexTrigger)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        let currentSurveyEvent = currentSurveyObserver.events
            .compactMap({ event -> Survey? in
                if event.time == 10 {
                    return event.value.element?.survey
                }
                return nil
            })
        
        let currentSurveyIndexEvent = currentSurveyObserver.events
            .compactMap({ event -> Int? in
                if event.time == 10 {
                    return event.value.element?.index
                }
                return nil
            })
        
        XCTAssertEqual(currentSurveyEvent.first!.id, surveys[1].id)
        XCTAssertEqual(currentSurveyIndexEvent.first!, 1)
    }
    
    func testSwipeToPreviousIndex() throws {
        let currentSurveyObserver = scheduler.createObserver((survey: Survey?, index: Int).self)
        
        useCase.listMock = [.surveys(.success(DataSurvey(data: surveys, meta: nil)))]
        
        output.surveys
            .drive()
            .disposed(by: disposeBag)
        
        output.currentSurvey
            .drive(currentSurveyObserver)
            .disposed(by: disposeBag)
        
        scheduler.createHotObservable([.next(0, .reload)])
            .bind(to: fetchSurveysTrigger)
            .disposed(by: disposeBag)
        
        scheduler.createHotObservable([.next(0, 2),
                                       .next(10, 1)])
            .bind(to: swipeToIndexTrigger)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        let currentSurveyEvent = currentSurveyObserver.events
            .compactMap({ event -> Survey? in
                if event.time == 10 {
                    return event.value.element?.survey
                }
                return nil
            })
        
        let currentSurveyIndexEvent = currentSurveyObserver.events
            .compactMap({ event -> Int? in
                if event.time == 10 {
                    return event.value.element?.index
                }
                return nil
            })
        
        XCTAssertEqual(currentSurveyEvent.first!.id, surveys[1].id)
        XCTAssertEqual(currentSurveyIndexEvent.first!, 1)
    }
    
    override func tearDown() {
        disposeBag = nil
        
        useCase = nil
        viewModel = nil
        
        output = nil
    }
}

private let surveys = [Survey(id: "d5de6a8f8f5f1cfe51bc", type: "survey",
                              attributes: Survey.Attributes(title: "Scarlett Bangkok",
                                                            description: "We'd love ot hear from you!",
                                                            coverImageUrl: "https://dhdbhh0jsld0o.cloudfront.net/m/1ea51560991bcb7d00d0_")),
                       Survey(id: "22de6a8f8f5f1cfe51bc", type: "survey",
                              attributes: Survey.Attributes(title: "Scarlett Bangkok",
                                                            description: "We'd love ot hear from you!",
                                                            coverImageUrl: "https://dhdbhh0jsld0o.cloudfront.net/m/1ea51560991bcb7d00d0_")),
                       Survey(id: "d5de6a8f8f5f1cfe51bc", type: "survey",
                              attributes: Survey.Attributes(title: "Scarlett Bangkok",
                                                            description: "We'd love ot hear from you!",
                                                            coverImageUrl: "https://dhdbhh0jsld0o.cloudfront.net/m/1ea51560991bcb7d00d0_")),
                       Survey(id: "d5de6a8f8f5f1cfe51bc", type: "survey",
                              attributes: Survey.Attributes(title: "Scarlett Bangkok",
                                                            description: "We'd love ot hear from you!",
                                                            coverImageUrl: "https://dhdbhh0jsld0o.cloudfront.net/m/1ea51560991bcb7d00d0_")),
                       Survey(id: "d5de6a8f8f5f1cfe51bc", type: "survey",
                              attributes: Survey.Attributes(title: "Scarlett Bangkok",
                                                            description: "We'd love ot hear from you!",
                                                            coverImageUrl: "https://dhdbhh0jsld0o.cloudfront.net/m/1ea51560991bcb7d00d0_"))]
