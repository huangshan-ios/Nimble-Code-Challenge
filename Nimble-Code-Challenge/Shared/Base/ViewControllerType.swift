//
//  BaseViewController.swift
//  Nimble-Code-Challenge
//
//  Created by Son Hoang on 24/06/2022.
//

import UIKit
import RxSwift

class ViewControllerType<V: ViewModelType, C: CoordinatorType>: UIViewController {
    
    var viewModel: V!
    var coordinator: C!
    
    var disposeBag = DisposeBag()
    
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
}
