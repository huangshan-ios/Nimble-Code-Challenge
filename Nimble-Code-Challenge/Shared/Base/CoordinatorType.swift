//
//  CoordinatorType.swift
//  Nimble-Code-Challenge
//
//  Created by Son Hoang on 24/06/2022.
//

import Foundation
import UIKit

protocol CoordinatorType: AnyObject {
    var navigationController: UINavigationController { get set }
    var parentCoordinator: CoordinatorType? { get set }
    
    func start()
    func start(_ coordinator: CoordinatorType)
    func finish(_ coordinator: CoordinatorType)
}

class Coordinator: CoordinatorType {
    var navigationController = UINavigationController()
    var parentCoordinator: CoordinatorType?
    var childCoordinators: [CoordinatorType]? = []
    
    func start() {
        fatalError("Start method must be implemented")
    }
    
    func start(_ coordinator: CoordinatorType) {
        childCoordinators?.append(coordinator)
        coordinator.parentCoordinator = self
        coordinator.start()
    }
    
    func finish(_ coordinator: CoordinatorType) {
        if let index = childCoordinators?.firstIndex(where: { $0 === coordinator }) {
            childCoordinators?.remove(at: index)
        }
    }
}

extension Coordinator {
    func logout() {
        let loginCoordinator = LoginCoordinator(isPresentation: true)
        loginCoordinator.navigationController = navigationController
        start(loginCoordinator)
    }
}
