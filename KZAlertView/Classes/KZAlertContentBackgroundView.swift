//
//  KZAlertContentBackgroundView.swift
//  KZAlertView
//
//  Created by Kagen Zhao on 2020/9/15.
//

import UIKit

class KZAlertContentBackgroundView: UIView {
    private let configuration: KZAlertConfiguration
        
    init(with configuration: KZAlertConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        layer.cornerRadius = configuration.cornerRadius
        backgroundColor = .clear
        setupShadowView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("不支持Xib / Storyboard")
    }
    
    private func setupShadowView() {
        layer.shadowColor = configuration.shadowColor.cgColor
        layer.shadowOffset = configuration.shadowOffset
        layer.shadowRadius = configuration.shadowRadius
        layer.shadowOpacity = configuration.shadowOpacity
    }
}
