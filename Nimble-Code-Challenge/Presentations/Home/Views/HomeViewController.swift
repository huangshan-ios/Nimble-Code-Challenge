//
//  HomeViewController.swift
//  Nimble-Code-Challenge
//
//  Created by Son Hoang on 27/06/2022.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class HomeViewController: ViewControllerType<HomeViewModel, HomeCoordinator> {
    
    private let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, String>>(configureCell: { dataSource, collectionView, indexPath, item in
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SurveyImageCell.className, for: indexPath) as? SurveyImageCell else {
            return UICollectionViewCell()
        }
        cell.setImage(item)
        return cell
    })
    
    @IBOutlet weak var surveyCollectionView: UICollectionView!
    @IBOutlet weak var bulletsView: BulletsView!
    @IBOutlet weak var surveyTitleLabel: UILabel!
    @IBOutlet weak var surveyDescriptionLabel: UILabel!
    
    private let fetchSurveysTrigger = PublishSubject<Void>()
    private let swipeTrigger = PublishSubject<SwipeDirection>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchSurveysTrigger.onNext(())
    }
    
    override func configureUIs() {
        let cellNib = UINib(nibName: SurveyImageCell.className, bundle: nil)
        surveyCollectionView.register(cellNib, forCellWithReuseIdentifier: SurveyImageCell.className)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = surveyCollectionView.frame.size
        layout.minimumLineSpacing = .leastNonzeroMagnitude
        surveyCollectionView.collectionViewLayout = layout
        
        surveyCollectionView.isPagingEnabled = true
        surveyCollectionView.showsHorizontalScrollIndicator = false
        surveyCollectionView.contentInsetAdjustmentBehavior = .never
    }
    
    override func configureBindings() {
        let input = HomeViewModel.Input(fetchSurveys: fetchSurveysTrigger.asObservable(),
                                        swipe: swipeTrigger.asObservable())
        
        let output = viewModel.transform(input)
        
        configureOutput(output)
        configureUITriggers(output)
    }
    
    override func onConfirmUnauthorizedClient() {
        coordinator.logout()
    }
    
    private func configureOutput(_ output: HomeViewModel.Output) {
        let collectionDataSourceDispo = output.surveys
            .map({ surveys in
                let coverImages = surveys.map({ $0.attributes.cover_image_url })
                return [SectionModel<String, String>(model: "", items: coverImages)]
            }).drive(surveyCollectionView.rx.items(dataSource: dataSource))
        
        let surveysDispo = output.surveys
            .drive(onNext: { [weak self] surveys in
                guard let self = self else { return }
                self.bulletsView.setNumOfBullets(surveys.count)
                self.updateSurveyContent(at: 0, surveys: surveys, isReload: true)
            })
        
        let currentSurveyDispo = output.currentIndex
            .withLatestFrom(output.surveys) { return ($0, $1) }
            .drive(onNext: { [weak self] currentIndex, surveys in
                guard let self = self else { return }
                self.updateSurveyContent(at: currentIndex, surveys: surveys)
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
        
        disposeBag.insert([collectionDataSourceDispo, surveysDispo,
                           currentSurveyDispo,
                           loadingDispo, errorDispo])
    }
    
    private func configureUITriggers(_ output: HomeViewModel.Output) {
        let swipeTriggerDispo = surveyCollectionView.rx
            .didScroll
            .withLatestFrom(output.currentIndex)
            .compactMap({ [weak self] index -> SwipeDirection? in
                guard let self = self else {
                    return nil
                }
                
                let scrollPos = Int(self.surveyCollectionView.contentOffset.x / self.view.frame.width)
                
                guard scrollPos != index else {
                    return nil
                }
                
                return scrollPos > index ? .forward : .backward
            }).bind(to: swipeTrigger)
        
        let refreshTriggerDispo = surveyCollectionView.rx
            .contentOffset
            .flatMap({ contentOffset -> Observable<Void> in
                guard contentOffset.x < -50 else {
                    return .empty()
                }
                return .just(())
            }).bind(to: fetchSurveysTrigger)
        
        disposeBag.insert([swipeTriggerDispo, refreshTriggerDispo])
    }
    
    private func updateSurveyContent(at index: Int, surveys: [Survey], isReload: Bool = false) {
        guard let survey = surveys[safe: index] else {
            return
        }
        
        bulletsView.switchTo(bulletAt: index)
        surveyTitleLabel.setTextWithFadeInAnimation(text: survey.attributes.title)
        surveyDescriptionLabel.setTextWithFadeInAnimation(text: survey.attributes.description)
        
        if isReload {
            surveyCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0),
                                              at: .top, animated: false)
        }
    }
}
