//
//  LoginViewController.swift
//  Nimble-Code-Challenge
//
//  Created by Son Hoang on 24/06/2022.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: ViewControllerType<LoginViewModel, LoginCoordinator> {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureUIs() {
        let placeholdes = ["Email", "Password"]
        let textFields = [emailTextField, passwordTextField]
        
        textFields.enumerated()
            .forEach { index, textfield in
                let attributePlaceholder = NSAttributedString(string: placeholdes[index],
                                                              attributes: [.foregroundColor: UIColor.whiteGray])
                textfield?.attributedPlaceholder = attributePlaceholder
            }
    }
    
    override func configureBindings() {
        let input = LoginViewModel.Input(email: emailTextField.rx.text.orEmpty.asObservable(),
                                         password: passwordTextField.rx.text.orEmpty.asObservable(),
                                         login: loginButton.rx.tap.asObservable(),
                                         forgotPassword: forgotPasswordButton.rx.tap.asObservable())
        
        let output = viewModel.transform(input)
        
        let enableLoginButtonDispo = output.enableLoginButton
            .drive(loginButton.rx.isEnabled)
        
        let loadingDispo = output.isLoading
            .emit(onNext: { [weak self] isLoading in
                guard let self = self else { return }
                self.showIndicator(isLoading)
            })
        
        let loginSuccessDispo = output.loginSuccess
            .emit(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.coordinator.navigateToHomeViewController()
            })
        
        let errorDispo = output.error
            .emit(onNext: { [weak self] error in
                guard let self = self, let error = error else {
                    return
                }
                self.handleError(error: error)
            })
        
        let forgotPasswordDispo = output.navigateToForgotPassword
            .emit(onNext: { _ in
                // TODO: Navigate to forgot password screen
            })
        
        disposeBag.insert([enableLoginButtonDispo,
                           loadingDispo,
                           loginSuccessDispo,
                           errorDispo,
                           forgotPasswordDispo])
    }
    
}
