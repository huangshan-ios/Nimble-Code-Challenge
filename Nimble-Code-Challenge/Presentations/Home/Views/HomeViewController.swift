//
//  HomeViewController.swift
//  Nimble-Code-Challenge
//
//  Created by Son Hoang on 27/06/2022.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewController: ViewControllerType<HomeViewModel, HomeCoordinator> {
    
    @IBOutlet weak var surveyCollectionView: UICollectionView!
    @IBOutlet weak var bulletsView: BulletsView!
    @IBOutlet weak var surveyTitleLabel: UILabel!
    @IBOutlet weak var surveyDescriptionLabel: UILabel!
    
    private let fetchSurveysTrigger = PublishSubject<Void>()
    private let loadMoreTrigger = PublishSubject<Void>()
    private let swipeTrigger = PublishSubject<SwipeDirection>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchSurveysTrigger.onNext(())
    }
    
    override func configureBindings() {
        let input = HomeViewModel.Input(fetchSurveys: fetchSurveysTrigger.asObservable(),
                                        swipe: swipeTrigger.asObservable())
        
        let output = viewModel.transform(input)
        
        let surveyImages = output.surveys
            .map { surveys in
                return surveys.map({ $0.attributes.cover_image_url })
            }.drive(onNext: { _ in
                // TODO: Bind to collection view
            })
        
        let currentSurveyDispo = Driver.combineLatest(output.surveys, output.currentIndex)
            .compactMap { surveys, currentIndex in
                return surveys[safe: currentIndex]
            }.drive(onNext: { [weak self] survey in
                guard let self = self else { return }
                self.surveyTitleLabel.text = survey.attributes.title
                self.surveyDescriptionLabel.text = survey.attributes.description
            })
        
        let currentIndexDispo = output.currentIndex
            .drive(onNext: { [weak self] index in
                guard let self = self else { return }
                self.bulletsView.switchTo(bulletAt: index)
            })
        
        let loadingDispo = output.isLoading
            .emit(onNext: { [weak self] isLoading in
                guard let self = self else { return }
                self.showIndicator(isLoading)
            })
        
        let errorDispo = output.error
            .emit(onNext: { [weak self] error in
                guard let self = self, let error = error else {
                    return
                }
                self.handleError(error: error)
            })
        
        disposeBag.insert([surveyImages, currentSurveyDispo,
                           currentIndexDispo,
                           loadingDispo, errorDispo])
    }
    
}
