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
    private var currentIndex: Int = 0
    
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
        
        let collectionDataSourceDispo = output.surveys
            .do(onNext: { [weak self] surveys in
                guard let self = self else { return }
                self.bulletsView.setNumOfBullets(surveys.count)
            })
            .map({ surveys in
                let coverImages = surveys.map({ $0.attributes.cover_image_url })
                return [SectionModel<String, String>(model: "", items: coverImages)]
            })
            .drive(surveyCollectionView.rx.items(dataSource: dataSource))
        
        let currentSurveyDispo = Driver.combineLatest(output.surveys, output.currentIndex)
            .compactMap { [weak self] surveys, currentIndex -> Survey? in
                guard let self = self else { return nil }
                self.currentIndex = currentIndex
                self.bulletsView.switchTo(bulletAt: currentIndex)
                return surveys[safe: currentIndex]
            }.drive(onNext: { [weak self] survey in
                guard let self = self else { return }
                self.surveyTitleLabel.setTextWithFadeInAnimation(text: survey.attributes.title)
                self.surveyDescriptionLabel.setTextWithFadeInAnimation(text: survey.attributes.description)
            })
        
        let loadingDispo = output.isLoading
            .emit(onNext: { [weak self] isLoading in
                guard let self = self else { return }
                self.surveyCollectionView.isScrollEnabled = !isLoading
                self.showIndicator(isLoading)
            })
        
        let errorDispo = output.error
            .emit(onNext: { [weak self] error in
                guard let self = self, let error = error else {
                    return
                }
                self.handleError(error: error)
            })
        
        let swipeTriggerDispo = surveyCollectionView.rx
            .didEndDecelerating
            .compactMap({ [weak self] _ -> SwipeDirection? in
                guard let self = self else {
                    return nil
                }
                
                let scrollPos = Int(self.surveyCollectionView.contentOffset.x / self.view.frame.width)
                
                guard scrollPos != self.currentIndex else {
                    return nil
                }
                
                return scrollPos > self.currentIndex ? .forward : SwipeDirection.backward
            })
            .bind(to: swipeTrigger)
        
        let refreshTriggerDispo = surveyCollectionView.rx
            .contentOffset
            .flatMap({ contentOffset -> Observable<Void> in
                guard contentOffset.x < -50 else {
                    return .empty()
                }
                return .just(())
            })
            .bind(to: fetchSurveysTrigger)
        
        disposeBag.insert([collectionDataSourceDispo, currentSurveyDispo,
                           loadingDispo, errorDispo,
                           swipeTriggerDispo, refreshTriggerDispo])
    }
}
