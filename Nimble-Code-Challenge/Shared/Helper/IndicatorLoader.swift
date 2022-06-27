//
//  IndicatorLoader.swift
//  Nimble-Code-Challenge
//
//  Created by Son Hoang on 27/06/2022.
//

import UIKit

class IndicatorLoader: NSObject {
    
    static let shared = IndicatorLoader()

    let indicator: UIActivityIndicatorView? = UIActivityIndicatorView(style: .white)

    let screen = UIScreen.main.bounds

    var appDelegate: AppDelegate {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                fatalError("sceneDelegate is not UIApplication.shared.delegate")
        }
        return appDelegate
    }
    
    var rootController: UIViewController? {
        guard let viewController = appDelegate.window?.rootViewController else {
            fatalError("There is no root controller")
        }
        return viewController
    }
    
    func show() {
        indicator?.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0)
        indicator?.frame.origin.x = (screen.width/2 - 20)
        indicator?.frame.origin.y = (screen.height/2 - 20)
        rootController?.view.addSubview(indicator!)
        indicator?.startAnimating()
    }
    
    func hide() {
        DispatchQueue.main.async {
            self.indicator?.stopAnimating()
            self.indicator?.removeFromSuperview()
        }
    }
}
