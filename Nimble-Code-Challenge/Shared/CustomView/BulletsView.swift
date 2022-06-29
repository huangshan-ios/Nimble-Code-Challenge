//
//  BulletsView.swift
//  Nimble-Code-Challenge
//
//  Created by Son Hoang on 30/06/2022.
//

import UIKit

class BulletsView: UIView {

    var currentBullet: Int = 0
    var numOfBullets: Int = 0
    
    func setNumOfBullets(_ bullets: Int) {
        numOfBullets = bullets
    }
    
    func switchTo(bulletAt index: Int) {
        currentBullet = index
    }
    
}
