//
//  SplashViewController.swift
//  Nimble-Code-Challenge
//
//  Created by Son Hoang on 07/07/2022.
//

import UIKit

class SplashViewController: ViewControllerType<SplashViewModel, SplashCoordinator> {
    
    @IBOutlet weak var transitionLogoImageView: UIImageView!
    @IBOutlet weak var logoImageView: UIImageView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Start the application
        coordinator.startApp()
    }
}
