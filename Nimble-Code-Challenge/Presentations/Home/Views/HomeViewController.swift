//
//  HomeViewController.swift
//  Nimble-Code-Challenge
//
//  Created by Son Hoang on 27/06/2022.
//

import UIKit

class HomeViewController: ViewControllerType<HomeViewModel, HomeCoordinator> {
    
    @IBOutlet weak var surveyCollectionView: UICollectionView!
    @IBOutlet weak var bulletsView: UIView!
    @IBOutlet weak var surveyTitleLabel: UILabel!
    @IBOutlet weak var surveyDescriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
