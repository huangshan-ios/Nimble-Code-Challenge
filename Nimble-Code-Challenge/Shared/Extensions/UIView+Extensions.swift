//
//  UIView+Extensions.swift
//  Nimble-Code-Challenge
//
//  Created by Son Hoang on 25/06/2022.
//

import UIKit
import SkeletonView

extension UIView {
    @IBInspectable var viewCornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    func showSkeletonAnimation(cornerRadius: Float = 8,
                               gradientColors: [UIColor] = [.white.withAlphaComponent(0.12), .white.withAlphaComponent(0.48), .white.withAlphaComponent(0.12)],
                               animation: SkeletonLayerAnimation? = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .leftRight),
                               transition: SkeletonTransitionStyle = .crossDissolve(1)) {
        skeletonCornerRadius = cornerRadius
        showAnimatedGradientSkeleton(usingGradient: .init(colors: gradientColors), animation: animation, transition: transition)
    }
}
