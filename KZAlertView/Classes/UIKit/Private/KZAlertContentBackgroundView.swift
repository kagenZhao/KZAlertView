//
//  KZAlertContentBackgroundView.swift
//  KZAlertView
//
//  Created by Kagen Zhao on 2020/9/15.
//

import UIKit

class KZAlertContentBackgroundView: UIView {
    private let configuration: KZAlertConfiguration
    private var userDidTouchAlertContent: (() -> ())?
    init(with configuration: KZAlertConfiguration, userDidTouchAlert: (() -> ())?) {
        self.configuration = configuration
        super.init(frame: .zero)
        userDidTouchAlertContent = userDidTouchAlert
        layer.cornerRadius = configuration.cornerRadius
        backgroundColor = .clear
        setupShadowView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupport Xib / Storyboard")
    }
    
    private func setupShadowView() {
        layer.shadowColor = configuration.shadowColor.cgColor
        layer.shadowOffset = configuration.shadowOffset
        layer.shadowRadius = configuration.shadowRadius
        layer.shadowOpacity = configuration.shadowOpacity
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let superReturnValue = super.point(inside: point, with: event)
        if superReturnValue {
            userDidTouchAlertContent?()
        }
        return superReturnValue
    }
}
