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
import SkeletonView

class HomeViewController: ViewControllerType<HomeViewModel, HomeCoordinator> {
    
    private let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, String>>(configureCell: { dataSource, collectionView, indexPath, item in
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SurveyImageCell.className, for: indexPath) as? SurveyImageCell else {
            return UICollectionViewCell()
        }
        cell.setImage(item)
        return cell
    })
    
    @IBOutlet weak var detailDateLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var surveyCollectionView: UICollectionView!
    @IBOutlet weak var bulletsView: BulletsView!
    @IBOutlet weak var surveyTitleLabel: UILabel!
    @IBOutlet weak var surveyDescriptionLabel: UILabel!
    @IBOutlet weak var takeSurveyButton: UIButton!
    @IBOutlet weak var shrimerView: UIView!
    
    private let fetchSurveysTrigger = PublishSubject<SurveyFetchType>()
    private let swipeTrigger = PublishSubject<Int>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchSurveysTrigger.onNext(.reload)
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
        
        configureSkeletonUIs(isLoading: true)
    }
    
    private func configureSkeletonUIs(isLoading: Bool) {
        if isLoading {
            shrimerView.showSkeletonAnimation()
        } else {
            UIView.animate(withDuration: 0.7, delay: 0.0,
                           options: UIView.AnimationOptions.curveEaseIn,
                           animations: { [weak self ] in
                guard let self = self else { return}
                self.shrimerView.alpha = 0
            })
            shrimerView.hideSkeleton()
        }
    }
    
    override func configureBindings() {
        let input = HomeViewModel.Input(fetchSurveys: fetchSurveysTrigger.asObservable(),
                                        swipeToIndex: swipeTrigger.asObservable())
        
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
                let sectionModel = SectionModel<String, String>(model: "", items: coverImages)
                return [sectionModel]
            })
            .drive(surveyCollectionView.rx.items(dataSource: dataSource))
        
        let surveysDispo = output.surveys
            .withLatestFrom(fetchSurveysTrigger.asDriver(onErrorJustReturn: .reload)) { (surveys: $0, fetchType: $1) }
            .drive(onNext: { [weak self] response in
                guard let self = self else {
                    return
                }
                
                let isReload = response.fetchType == .reload
                let index = isReload ? 0 : self.bulletsView.currentBullet + 1
                
                guard let survey = response.surveys[safe: index] else {
                    return
                }
                
                self.bulletsView.setNumOfBullets(response.surveys.count)
                
                if isReload {
                    self.configureSkeletonUIs(isLoading: false)
                } else {
                    let indexPath = IndexPath(item: index, section: 0)
                    self.surveyCollectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
                }
                self.updateSurveyContent(survey: survey, index: index, isReload: isReload)
            })
        
        let currentSurveyDispo = output.currentSurvey
            .drive(onNext: { [weak self] result in
                guard
                    let self = self,
                    let survey = result.survey
                else {
                    return
                }
                self.updateSurveyContent(survey: survey, index: result.index)
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
            .compactMap({ [weak self] index -> Int? in
                guard let self = self else {
                    return nil
                }
                return Int(self.surveyCollectionView.contentOffset.x / self.view.frame.width)
            }).bind(to: swipeTrigger)
        
        let refreshTriggerDispo = surveyCollectionView.rx
            .contentOffset
            .compactMap({ [weak self] contentOffset -> SurveyFetchType? in
                guard let self = self else {
                    return nil
                }
                if contentOffset.x < -50 {
                    return .reload
                }
                if contentOffset.x + UIScreen.main.bounds.width > self.surveyCollectionView.contentSize.width + 50 {
                    return .loadMore
                }
                return nil
            }).bind(to: fetchSurveysTrigger)
        
        let takeSurveyButtonDispo = takeSurveyButton.rx.tap
            .withLatestFrom(output.currentSurvey)
            .subscribe(onNext: { [weak self] result in
                guard let self = self,
                      let survey = result.survey
                else {
                    return
                }
                self.coordinator.gotoSurveyDetail(survey: survey)
            })
        
        disposeBag.insert([swipeTriggerDispo, refreshTriggerDispo,
                           takeSurveyButtonDispo])
    }
    
    private func updateSurveyContent(survey: Survey, index: Int, isReload: Bool = false) {
        bulletsView.switchTo(bulletAt: index)
        surveyTitleLabel.setTextWithFadeInAnimation(text: survey.attributes.title)
        surveyDescriptionLabel.setTextWithFadeInAnimation(text: survey.attributes.description)
        
        if isReload {
            surveyCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0),
                                              at: .top, animated: false)
        }
    }
}
