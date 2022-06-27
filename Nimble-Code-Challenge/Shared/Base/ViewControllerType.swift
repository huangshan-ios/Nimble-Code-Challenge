//
//  BaseViewController.swift
//  Nimble-Code-Challenge
//
//  Created by Son Hoang on 24/06/2022.
//

import UIKit
import RxSwift
import RxRelay

class ViewControllerType<V: ViewModelType, C: CoordinatorType>: UIViewController {
    
    var viewModel: V!
    weak var coordinator: C!
    
    let disposeBag = DisposeBag()
    
    init(viewModel: V, coordinator: C, controller: ViewControllerType.Type) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: controller.className, bundle: Bundle(for: controller))
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUIs()
        configureBindings()
    }
    
    func configureUIs() {}
    
    func configureBindings() {}
    
    func handleError(error: AppError) {
        showError(error: error)
    }
    
    func showIndicator(_ isLoading: Bool) {
        if isLoading {
            IndicatorLoader.shared.show()
        } else {
            IndicatorLoader.shared.hide()
        }
    }
}

// MARK: Private functions
extension ViewControllerType {
    private func showError(error: AppError) {
        let alertController = UIAlertController(title: "Oops there was an error!",
                                                message: error.message,
                                                preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            switch error {
            case .unauthorizedClient:
                self.onConfirmUnauthorizedClient()
            default:
                self.onConfirmErrorDialog()
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            self.onCancelErrorDialog()
        }))
        
        present(alertController, animated: false)
    }
}

// MARK: - Utilities functions
extension ViewControllerType {
    func onConfirmErrorDialog() {}
    func onCancelErrorDialog() {}
    func onConfirmUnauthorizedClient() {}
}
