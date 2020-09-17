//
//  KZAlertBackgroundView.swift
//  KZAlertView
//
//  Created by zhaoguoqing on 2020/9/13.
//

import UIKit
import SnapKit

internal class KZAlertBackgroundView: UIView {

    private let configuration: KZAlertConfiguration
    
    private var backgroundVisualEffectView: UIVisualEffectView?
    private var darkBackgroundView: UIView!
    
    init(with configuration: KZAlertConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        backgroundColor = .clear
        clipsToBounds = true
        setupBlurBackground()
        setupDarkBackground()
    }
    
    required init?(coder: NSCoder) {
        fatalError("UnsupportXib / Storyboard")
    }
    
    private func setupBlurBackground() {
        if configuration.isBlurBackground {
            let blurEffect = UIBlurEffect(style: .extraLight)
            backgroundVisualEffectView = UIVisualEffectView(effect: blurEffect)
            backgroundVisualEffectView?.isUserInteractionEnabled = false
            addSubview(backgroundVisualEffectView!)
            backgroundVisualEffectView?.snp.makeConstraints({ (make) in
                make.edges.equalTo(UIEdgeInsets.zero)
            })
        }
    }
    
    private func setupDarkBackground() {
        if configuration.isDarkBackground {
            darkBackgroundView = UIView(frame: bounds)
            darkBackgroundView.backgroundColor = configuration.darkBackgroundColor
            darkBackgroundView.isUserInteractionEnabled = false
            addSubview(darkBackgroundView)
            darkBackgroundView?.snp.makeConstraints({ (make) in
                make.edges.equalTo(UIEdgeInsets.zero)
            })
        }
    }
}
