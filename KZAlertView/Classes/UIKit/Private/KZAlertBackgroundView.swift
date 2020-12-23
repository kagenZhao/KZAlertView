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
    
    init?(with configuration: KZAlertConfiguration) {
        if !configuration.fullCoverageContainer { return nil }
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
            let blurEffect: UIBlurEffect
            if #available(iOS 13, *) {
                switch configuration.themeMode  {
                case .light:
                    blurEffect = UIBlurEffect.init(style: .systemMaterialLight)
                case .dark:
                    blurEffect = UIBlurEffect.init(style: .systemMaterialDark)
                case .followSystem:
                    blurEffect = UIBlurEffect.init(style: .systemMaterial)
                }
            } else {
                blurEffect = UIBlurEffect.init(style: configuration.themeMode.isDark(at: self) ? .dark : .extraLight)
            }
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
