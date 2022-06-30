//
//  BulletsView.swift
//  Nimble-Code-Challenge
//
//  Created by Son Hoang on 30/06/2022.
//

import UIKit
import SnapKit

class BulletsView: UIView {
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        return scrollView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = 4
        return stackView
    }()
    
    var currentBullet: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUIs()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUIs()
    }
    
    private func configureUIs() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.top.bottom.equalToSuperview()
            make.trailing.lessThanOrEqualToSuperview()
        }
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.top.bottom.equalToSuperview().offset(4)
        }
    }
    
    func setNumOfBullets(_ bullets: Int) {
        stackView.arrangedSubviews.forEach({ $0.removeFromSuperview() })
        
        (1...bullets).forEach { _ in
            let view = createBulletView()
            stackView.addArrangedSubview(view)
        }
    }
    
    func switchTo(bulletAt index: Int) {
        let previousBullet = stackView.subviews.enumerated().first(where: { $0.offset == currentBullet }).map { $0.element }
        let newBullet = stackView.subviews.enumerated().first(where: { $0.offset == index }).map { $0.element }
        previousBullet?.backgroundColor = .white.withAlphaComponent(0.3)
        newBullet?.backgroundColor = .white
        currentBullet = index
    }
    
    private func createBulletView() -> UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = .white.withAlphaComponent(0.3)
        view.viewCornerRadius = 4
        view.snp.makeConstraints { make in
            make.width.height.equalTo(8)
        }
        return view
    }
}
