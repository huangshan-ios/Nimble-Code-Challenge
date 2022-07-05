//
//  UILabel+Extensions.swift
//  Nimble-Code-Challenge
//
//  Created by Son Hoang on 30/06/2022.
//

import UIKit
import SkeletonView

extension UILabel {
    func setTextWithFadeInAnimation(text: String, duration: TimeInterval = 0.5, delay: TimeInterval = 0.0) {
        self.alpha = 0.0
        UIView.animate(withDuration: duration, delay: delay,
                       options: UIView.AnimationOptions.curveEaseIn,
                       animations: { [weak self ] in
            guard let self = self else { return}
            self.text = text
            self.alpha = 1.0
        })
    }
}
