//
//  UIView+Extensions.swift
//  Nimble-Code-Challenge
//
//  Created by Son Hoang on 25/06/2022.
//

import UIKit

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
}
