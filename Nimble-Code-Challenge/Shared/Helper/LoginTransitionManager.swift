//
//  LoginTransitionManager.swift
//  Nimble-Code-Challenge
//
//  Created by Son Hoang on 07/07/2022.
//

import UIKit

final class LoginTransitionManager: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let duration: TimeInterval
    
    init(duration: TimeInterval) {
        self.duration = duration
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to),
            let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as? SplashViewController
        else {
            return
        }
        
        toViewController.view.alpha = 0.0
        transitionContext.containerView.addSubview(fromViewController.view)
        transitionContext.containerView.addSubview(toViewController.view)
        
        let splashLogoImageView = fromViewController.logoImageView
        let transitionLogoImageView = fromViewController.transitionLogoImageView
        
        let transitionY = transitionLogoImageView?.frame.origin.y ?? .leastNonzeroMagnitude
        let scaleX = (transitionLogoImageView?.frame.size.width ?? .leastNonzeroMagnitude) / (splashLogoImageView?.frame.size.width ?? .leastNonzeroMagnitude)
        let scaleY = (transitionLogoImageView?.frame.size.height ?? .leastNonzeroMagnitude) / (splashLogoImageView?.frame.size.height ?? .leastNonzeroMagnitude)
        
        let logoPadding: CGFloat = 5
        
        UIView.animate(withDuration: duration, delay: 0.0, options: [], animations: {
            splashLogoImageView?.frame.origin.y = transitionY - logoPadding
            splashLogoImageView?.transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration - 0.1, execute: { [weak self] in
            guard let self = self else { return }
            UIView.animate(withDuration: self.duration, animations: {
                toViewController.view.alpha = 1.0
            }, completion: { (completed) in
                fromViewController.view.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        })
    }
}

extension LoginTransitionManager: UINavigationControllerDelegate {
    func navigationController(
        _ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation,
        from fromVC: UIViewController,
        to toVC: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
            return self
    }
}
